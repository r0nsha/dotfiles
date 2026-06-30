require("init")

swayimg.imagelist.set_order("alpha")
swayimg.gallery.set_text("topleft", { "Set background to {name}" })

swayimg.gallery.on_key("Return", function()
  local e = swayimg.gallery.get_image()
  if e and e.path then
    io.write(e.path, "\n")
    io.stdout:flush()
    swayimg.exit(0)
  end
  swayimg.exit(1)
end)
