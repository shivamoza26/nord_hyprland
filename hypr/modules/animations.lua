--Animations

hl.curve("snap", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "snap", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "snap", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "snap" })

hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "snap" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "snap" })

hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "snap" })

hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "snap" })
hl.animation({ leaf = "borderangle", enabled = false })

hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2, bezier = "snap", style = "slide 15%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2, bezier = "snap", style = "slide 15%" })
