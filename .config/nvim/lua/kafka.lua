-- TODO: refactor this messy module
local notify = vim.schedule_wrap(vim.notify)

---@class KafkaPod
---@field metadata { name: string, labels: { app: string } }

local state_file = vim.fn.stdpath("data") .. "/kafka_state.json"

---@type string?
local namespace
---@type KafkaPod?
local last_pod
---@type string?
local last_topic
---@type string?
local last_msg

local function save_state()
  local state = {
    namespace = namespace,
    last_pod = last_pod,
    last_topic = last_topic,
    last_msg = last_msg,
  }
  local json = vim.json.encode(state)
  vim.schedule(function() vim.fn.writefile({ json }, state_file) end)
end

local function load_state()
  if vim.fn.filereadable(state_file) == 0 then return end
  local lines = vim.fn.readfile(state_file)
  if #lines == 0 then return end
  local ok, state = pcall(vim.json.decode, table.concat(lines, ""))
  if not ok or type(state) ~= "table" then return end
  namespace = state.namespace
  last_pod = state.last_pod
  last_topic = state.last_topic
  last_msg = state.last_msg
end

---@param callback fun(namespaces: string[])
local function get_namespaces(callback)
  notify("Getting namespaces...", vim.log.levels.INFO)
  vim.system(
    { "kubectl", "get", "namespaces", "-o", "jsonpath={.items[*].metadata.name}" },
    { text = true },
    function(out)
      if out.code ~= 0 then
        notify("Error getting namespaces.", vim.log.levels.ERROR)
        return
      end

      local namespaces = vim.split(out.stdout, " ", { trimempty = true })
      callback(namespaces)
    end
  )
end

---@param callback? fun(namespace: string)
local function select_namespace(callback)
  get_namespaces(function(namespaces)
    vim.schedule(function()
      vim.ui.select(namespaces, { prompt = "Select namespace:" }, function(selected)
        if selected then
          namespace = selected
          last_pod = nil
          save_state()
          notify("Namespace set to: " .. namespace, vim.log.levels.INFO)
          if callback then callback(selected) end
        end
      end)
    end)
  end)
end

---@param callback fun(pod: KafkaPod)
local function with_kafka_pod(callback)
  if not namespace then
    select_namespace(function() with_kafka_pod(callback) end)
    return
  end

  notify("Verifying namespace " .. namespace .. "...", vim.log.levels.INFO)
  vim.system({ "kubectl", "get", "namespace", namespace }, { text = true }, function(out)
    if out.code ~= 0 then
      notify(
        "Namespace " .. namespace .. " not found. Please select a new one.",
        vim.log.levels.WARN
      )
      namespace = nil
      last_pod = nil
      save_state()
      select_namespace(function() with_kafka_pod(callback) end)
      return
    end

    notify("Getting Kafka pod...", vim.log.levels.INFO)
    vim.system(
      { "kubectl", "get", "pods", "-n", namespace, "-o", "json" },
      { text = true },
      function(pod_out)
        if pod_out.code ~= 0 then
          notify("Error getting Kafka pod.", vim.log.levels.ERROR)
          return
        end

        local json = vim.json.decode(pod_out.stdout)
        local kafka_pods = vim.tbl_filter(
          function(item) return item.metadata.labels and item.metadata.labels.app == "kafka" end,
          json.items
        )

        if #kafka_pods == 0 then
          notify("No Kafka pod found.", vim.log.levels.WARN)
          return
        end

        last_pod = kafka_pods[1]
        save_state()
        callback(last_pod)
      end
    )
  end)
end

---@param pod KafkaPod
---@param topic string
---@param msg string
local function send_message(pod, topic, msg)
  last_msg = msg
  save_state()

  notify(
    "Sending message to Kafka topic " .. topic .. " in namespace " .. namespace,
    vim.log.levels.INFO
  )

  vim.system({
    "kubectl",
    "exec",
    "-i",
    "-n",
    namespace,
    pod.metadata.name,
    "--",
    "kafka-console-producer",
    "--broker-list",
    "localhost:9092",
    "--topic",
    topic,
  }, { stdin = msg, text = true }, function(out)
    if out.code == 0 then
      notify("Message sent successfully.", vim.log.levels.INFO)
    else
      notify("Error sending message.", vim.log.levels.ERROR)
    end
  end)
end

---@return string?
local function msg_from_buf_contents()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local msg = table.concat(lines, "\n"):gsub("\n", "")

  local ok, _ = pcall(vim.json.decode, msg)
  if not ok then
    notify("Buffer content is not valid JSON.", vim.log.levels.ERROR)
    return
  end

  return msg
end

---@param pod KafkaPod
---@param callback fun(topics: string[])
local function get_topics(pod, callback)
  notify("Getting Kafka topics...", vim.log.levels.INFO)
  vim.system({
    "kubectl",
    "exec",
    "-n",
    namespace,
    pod.metadata.name,
    "--",
    "kafka-topics",
    "--list",
    "--bootstrap-server",
    "localhost:9092",
  }, { text = true }, function(out)
    if out.code ~= 0 then
      notify("Error getting Kafka topics.", vim.log.levels.ERROR)
      return
    end

    local topics = vim.tbl_filter(function(line) return line ~= "" end, vim.split(out.stdout, "\n"))

    callback(topics)
  end)
end

---@param topics string[]
---@param callback fun(topic: string)
local function select_topic(topics, callback)
  vim.ui.select(topics, { prompt = "Select Kafka topic:" }, function(selected)
    if selected then
      last_topic = selected
      save_state()
      callback(selected)
    end
  end)
end

local function kafka_send_buf()
  local msg = msg_from_buf_contents()
  if not msg then return end

  with_kafka_pod(function(pod)
    get_topics(pod, function(topics)
      vim.schedule(function()
        select_topic(topics, function(topic) send_message(pod, topic, msg) end)
      end)
    end)
  end)
end

local function kafka_send_last_topic()
  if not last_pod then
    notify("No previous pod found. Run :KafkaSendBuf first.", vim.log.levels.WARN)
    return
  end

  if not last_topic then
    notify("No previous topic to send.", vim.log.levels.WARN)
    return
  end

  local msg = msg_from_buf_contents()
  if not msg then return end

  send_message(last_pod, last_topic, msg)
end

local function kafka_send_last_msg()
  if not last_pod then
    notify("No previous pod found. Run :KafkaSendBuf first.", vim.log.levels.WARN)
    return
  end

  if not last_topic then
    notify("No previous topic to send.", vim.log.levels.WARN)
    return
  end

  if not last_msg then
    notify("No previous message to send.", vim.log.levels.WARN)
    return
  end

  send_message(last_pod, last_topic, last_msg)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function(args)
    vim.api.nvim_buf_create_user_command(args.buf, "KafkaSendBuf", kafka_send_buf, {})
  end,
})

load_state()

vim.api.nvim_create_user_command("KafkaSelectNamespace", select_namespace, {})
vim.api.nvim_create_user_command("KafkaSendLastTopic", kafka_send_last_topic, {})
vim.api.nvim_create_user_command("KafkaSendLastMsg", kafka_send_last_msg, {})
