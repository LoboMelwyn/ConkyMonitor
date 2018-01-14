pos_X = 195
pos_Y = 290
settings_table = {
	{
		name='time',
		arg='%S',
		max=60,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xffffff,
		fg_alpha=0.6,
		x=3*pos_X/2 + 2,
		y=pos_Y,
		radius=100,
		thick=10,
		start_angle=0,
		end_angle=360,
	},
	{
		name='time',
		arg='%M',
		max=60,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xffffff,
		fg_alpha=0.6,
		x=3*pos_X/2 + 2,
		y=pos_Y,
		radius=85,
		thick=10,
		start_angle=0,
		end_angle=360,
	},
	{
		name='time',
		arg='%I',
		max=12,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xffffff,
		fg_alpha=0.6,
		x=3*pos_X/2 + 2,
		y=pos_Y,
		radius=70,
		thick=10,
		start_angle=0,
		end_angle=360,
	},
	{
		name='cpu',
		arg='cpu1',
		max=100,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xDD3232,
		fg_alpha=0.6,
		x=2*pos_X/3 - 15,
		y=pos_Y+160,
		radius=25,
		thick=10,
		start_angle=225,
		end_angle=495,
	},
	{
		name='cpu',
		arg='cpu2',
		max=100,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0x32DD32,
		fg_alpha=0.6,
		x=2*pos_X/3 - 15,
		y=pos_Y+160,
		radius=40,
		thick=10,
		start_angle=225,
		end_angle=495,
	},
	{
		name='cpu',
		arg='cpu3',
		max=100,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xDD3232,
		fg_alpha=0.6,
		x=2*pos_X/3 - 15,
		y=pos_Y+160,
		radius=55,
		thick=10,
		start_angle=225,
		end_angle=495,
	},
	{
		name='cpu',
		arg='cpu4',
		max=100,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0x32DD32,
		fg_alpha=0.6,
		x=2*pos_X/3 - 15,
		y=pos_Y+160,
		radius=70,
		thick=10,
		start_angle=225,
		end_angle=495,
	},
	{
		name='memperc',
		arg='',
		max=100,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0x32DD32,
		fg_alpha=0.6,
		x=5*pos_X/4,
		y=pos_Y+160,
		radius=40,
		thick=10,
		start_angle=230,
		end_angle=490,
	},
	{
		name='swapperc',
		arg='',
		max=100,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xDD3232,
		fg_alpha=0.6,
		x=7*pos_X/4,
		y=pos_Y+160,
		radius=40,
		thick=10,
		start_angle=230,
		end_angle=490,
	},
	{
		name='downspeedf',
		arg='wlp2s0',
		max=1024,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0x00A3FF,
		fg_alpha=0.6,
		x=2*pos_X/3 - 15,
		y=pos_Y+280,
		radius=50,
		thick=10,
		start_angle=225,
		end_angle=495,
	},
	{
		name='upspeedf',
		arg='wlp2s0',
		max=1024,
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xFFA300,
		fg_alpha=0.6,
		x=2*pos_X/3 - 15,
		y=pos_Y+280,
		radius=35,
		thick=10,
		start_angle=225,
		end_angle=495,
	},
	{
		name='exec',
		arg='rhythmbox-client --print-playing-format=%te | tr \':\' \'.\'',
		max = 4,
		max_script='exec rhythmbox-client --print-playing-format=%td | tr \':\' \'.\'',
		bg_color=0xffffff,
		bg_alpha=0.1,
		fg_color=0xFFA300,
		fg_alpha=0.6,
		x=3*pos_X/2 + 2,
		y=pos_Y+280,
		radius=35,
		thick=10,
		start_angle=0,
		end_angle=360,
	},
}

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_text(cr, xc, yc, color, text, text_size)
	font="GE Inspira"
	font_slant=CAIRO_FONT_SLANT_NORMAL
	font_face=CAIRO_FONT_WEIGHT_BOLD
	text_correction = string.len( text ) * (text_size/3.5)
	
	cairo_select_font_face (cr, font, font_slant, font_face);
	cairo_set_font_size (cr, text_size)
	cairo_set_source_rgba (cr,rgb_to_r_g_b(color,1))
	cairo_move_to (cr,xc - text_correction,yc)
	cairo_show_text (cr,text)
	cairo_stroke (cr)
end

function draw_ring(cr, xc, yc, radius, sa, ea, color, alpha, thick)
	cairo_arc(cr,xc,yc,radius,sa,ea)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(color,alpha))
	cairo_set_line_width(cr,thick)
	cairo_stroke(cr)
end

function circle(cr, t, pt)
	local xc, yc, circle_r, sa, ea, thick = pt['x'], pt['y'], pt['radius'], pt['start_angle'], pt['end_angle'], pt['thick']
	local bgc, bga, fgc, fga = pt['bg_color'], pt['bg_alpha'], pt['fg_color'], pt['fg_alpha']
	local text, text_color, text_size = pt['text'], pt['text_color'], pt['text_size']
	
	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=t*(angle_f-angle_0)
	
	draw_ring(cr,xc,yc,circle_r,angle_0,angle_f,bgc,bga,thick)
	
	draw_ring(cr,xc,yc,circle_r,angle_0,angle_0+t_arc,fgc,fga,thick)
	if text ~= nil then
		draw_text(cr, xc, yc+(2*text_size)+7, text_color, text, text_size)
		draw_text(cr, xc, yc+(text_size/2), text_color, (t*100).."%", text_size)
	end
end

function conky_circles()
	add_disk_info_to_tables()
	local function setup_circle(cr,pt)
		local str=''
		local value=0
		local denom = 0
		str=string.format('${%s %s}', pt['name'], pt['arg'])
		str=conky_parse(str)
		
		value=tonumber(str)
		denom=tonumber(pt['max'])
		if value == nil then value = 0 end
		if pt['max_script'] ~= nil then
			local a=string.format('${%s}', pt['max_script'])
			a=conky_parse(a)
			denom=tonumber(a)
		end
		if denom == nil or denom == 0 then pct = 0 else pct=value/denom end
		
		circle(cr,pct,pt)
	end
	
	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

	local cr=cairo_create(cs)	

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then
		for i in pairs(settings_table) do
			setup_circle(cr,settings_table[i])
		end
	end
end

function add_disk_info_to_tables()
    local handler = io.popen("mount -l | grep '^/' | awk '{print $3,$7}' | tr '[-]' '\r' | tr '\n' ','")
    local disk_list = handler:read("*a")
    local i = 12
    local xdist = -150
    for disk in string.gmatch(disk_list,"([^,]+)") do
	local j = 0
	local b = {}
        for d in string.gmatch(disk,"([%S]+)") do
            if j == 0 then
                b["name"] = "fs_used_perc"
                b["arg"] = d
                if d == "/" then
                    b["text"] = "Root"
                else
                    b["text"] = "NoLabel"
                end
                b["max"] = 100
                b["bg_color"] = 0xffffff
                b["bg_alpha"] = 0.1
                b["fg_color"] = 0xffff88
                b["fg_alpha"] = 0.6
                b["x"] = pos_X+xdist
                b["y"] = pos_Y+400
                b["radius"] =35
                b["thick"] = 10
                b["start_angle"] = 225
                b["end_angle"] = 495
                b["text_color"] = 0x553399
                b["text_size"] = 18
		j = j + 1
		xdist = xdist + 100
            else
                b["text"] = d
            end
            i = i + 1
	end
	settings_table[i] = b
    end
end
