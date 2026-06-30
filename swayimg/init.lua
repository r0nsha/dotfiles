swayimg.text.set_size(18)
swayimg.text.set_foreground(0xffc6c6c6)

swayimg.gallery.set_window_color(0xff000000)
swayimg.gallery.set_border_color(0xffffffff)
swayimg.gallery.enable_embedded_thumb(true)
swayimg.gallery.set_thumb_size(400)
swayimg.gallery.set_aspect("fill")
swayimg.gallery.set_text("topleft", { "{name}" })

swayimg.gallery.on_key("q", function() swayimg.exit(1) end)

local function pan(dx, dy)
  local w = swayimg.get_window_size()
  local p = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(
    math.floor(p.x + dx * w.width / 10),
    math.floor(p.y + dy * w.height / 10)
  )
end
swayimg.viewer.on_key("h", function() pan(-1, 0) end)
swayimg.viewer.on_key("j", function() pan(0, 1) end)
swayimg.viewer.on_key("k", function() pan(0, -1) end)
swayimg.viewer.on_key("l", function() pan(1, 0) end)

swayimg.gallery.on_key("h", function() swayimg.gallery.switch_image("left") end)
swayimg.gallery.on_key("j", function() swayimg.gallery.switch_image("down") end)
swayimg.gallery.on_key("k", function() swayimg.gallery.switch_image("up") end)
swayimg.gallery.on_key("l", function() swayimg.gallery.switch_image("right") end)

swayimg.slideshow.on_key("h", function() swayimg.slideshow.switch_image("prev") end)
swayimg.slideshow.on_key("j", function() swayimg.slideshow.switch_image("next_dir") end)
swayimg.slideshow.on_key("k", function() swayimg.slideshow.switch_image("prev_dir") end)
swayimg.slideshow.on_key("l", function() swayimg.slideshow.switch_image("next") end)
