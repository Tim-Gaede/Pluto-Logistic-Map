### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 0be1266a-01bc-11eb-3a24-57c28ea50d21
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 129e0e82-01bc-11eb-2142-91b9da370423
begin
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	using Images
end

# ╔═╡ 3e8c8538-01bb-11eb-07d6-b573a23076b4
function logistic(r, iterations)
	x = 0.5
	
	for i in (1 : iterations)
		x = r*x*(1-x)
	end
	
	
	x
end

# ╔═╡ a572eb02-01bb-11eb-0cf8-793120c966db
logistic(2.8, 1115)

# ╔═╡ e898fcd4-0236-11eb-2311-2365573a45bc
image_logistic = Array{RGB{Normed{UInt8,8}}}(undef, 2160,3840)

# ╔═╡ 26b0a1c2-022b-11eb-3ccf-b7735291e10a
function y_from_line(xy1, xy2, x)
	
	if xy2[1] - xy1[1] !== 0
		slope = (xy2[2] - xy1[2]) /
				(xy2[1] - xy1[1])

		y_intercept = xy1[2] - xy1[1] * slope

		return slope*x + y_intercept
	else
	
	end
end

# ╔═╡ e9f3f53a-022b-11eb-1ba2-9b0e8f24a2d8
function x_from_line(xy1, xy2, y)
	
	if xy2[1] - xy1[1] !== 0
		slope = (xy2[2] - xy1[2]) /
	            (xy2[1] - xy1[1])
	
	
		#x_intercept = xy2[1] - xy2[2] / slope
		y_intercept = xy1[2] - xy1[1] * slope

		return (y - y_intercept) / slope
	else
		return xy1[1]
	end
	 
end

# ╔═╡ ceb8ad24-0230-11eb-3f5b-0d23a7cfd48b


# ╔═╡ 77b9e59a-021b-11eb-2c19-330fe7798797
mutable struct canvas
	image::Array{RGB{Normed{UInt8,8}},2}#(undef, rows, cols)
	
	xL::Float64 # left
	xR::Float64 # right
	
	yT::Float64 # top
	yB::Float64 # bottom
end

# ╔═╡ 1647195e-0237-11eb-09aa-55d2c9654798
canvas_logistic = canvas(image_logistic, 2.4, 4.0, 1.0, 0.0)

# ╔═╡ eb689b08-0237-11eb-372b-9f874134c5f1
canvas_logistic.image

# ╔═╡ 5c4c8cf4-023c-11eb-2b5c-152e7f8c9855
begin
	myPath = "/home/timothy/jl_files/Pluto/Mine/Logistic Map/"

	save(File(format"PNG", "myfile.png"), canvas_logistic.image, path=myPath)
end

# ╔═╡ 233a6d88-01be-11eb-0cc2-f97d52d0af18
function row_col(cnvs::canvas, xy)
	y_span = cnvs.yT - cnvs.yB
	rows = size(cnvs.image)[1]
	
	rows_per_unit = rows / y_span
	
	y_frac = (cnvs.yT - xy[2]) / y_span
	
	row = convert(Int64, round(y_frac * rows))
	
	
	x_span = cnvs.xR - cnvs.xL
	cols = size(cnvs.image)[2]
	
	cols_per_unit = cols / x_span
	
	x_frac = (xy[1] - cnvs.xL) / x_span
	
	col = convert(Int64, round(x_frac * cols))
	
	
	row, col
end

# ╔═╡ 86fb1a9a-022a-11eb-279a-65ffb8591362
function row_num(cnvs::canvas, y)
	y_span = cnvs.yT - cnvs.yB
	rows = size(cnvs.image)[1]
	
	rows_per_unit = rows / y_span
	
	y_frac = (cnvs.yT - y) / y_span
	
	
	convert(Int64, round(y_frac * rows)) 
end

# ╔═╡ b5b4afea-022a-11eb-205a-559f25349798
function col_num(cnvs::canvas, x)
 	x_span = cnvs.xR - cnvs.xL
	cols = size(cnvs.image)[2]
	
	cols_per_unit = cols / x_span
	
	x_frac = (x - cnvs.xL) / x_span
	
	
	convert(Int64, round(x_frac * cols))	 
end

# ╔═╡ b0c2df32-0222-11eb-232d-b13654008d28
function x_coord(cnvs::canvas, col)
		
	x_span = cnvs.xR - cnvs.xL
	cols = size(cnvs.image)[2] 
	 
	col_frac = col / cols
	
	x_frac = col_frac * x_span
	
	
	cnvs.xL + x_frac		 
end

# ╔═╡ 05748a66-0238-11eb-1952-978e7c91bcf4
function plot_logistic_map!(cnvs, iterations1, iterations2)
	for col in (1 : size(cnvs.image)[2])
		r = x_coord(cnvs, col)
		
		
		x = 0.5	
		for i1 in (1 : iterations1)
			x = r*x*(1-x)
		end
	
	
	 	for i2 in (1 : iterations2)
			x = r*x*(1-x)
			row = row_num(cnvs, x)

			if row >= 1  &&  row <= size(cnvs.image)[1]
				cnvs.image[row, col] = RGB(0.0, 0.0, 0.0)
			end
		end
		
		 
		
	end
end

# ╔═╡ b0ec43fe-0224-11eb-1849-c799b8999edc
function y_coord(cnvs::canvas, row)
		
	y_span = cnvs.yT - cnvs.yB
	rows = size(cnvs.image)[1]
	
	row_frac = row / rows
	
	y_frac = row_frac * y_span
	
	cnvs.yT - y_frac
end

# ╔═╡ a8a8f63a-0225-11eb-33e6-6f9a47dfb94e
function wipe!(cnvs::canvas, color)
	
	rows, cols = size(cnvs.image)
	
	for row in (1 : rows)
		for col in (1 : cols)
			cnvs.image[row, col] = color
		end
	end
end

# ╔═╡ 5f727268-0237-11eb-3ab8-bf67672322eb
wipe!(canvas_logistic, RGB(1, 1, 1))

# ╔═╡ f3b33722-023a-11eb-2ecb-ed657c2b4ec5
begin
	wipe!(canvas_logistic, RGB(1.0, 1.0, 1.0))
	
	plot_logistic_map!(canvas_logistic, 21600, 2160)

	canvas_logistic.image
end

# ╔═╡ 9594b112-021e-11eb-1563-ab181d629d29
function scales_equal(cnvs::canvas)
	y_span = cnvs.yT - cnvs.yB
	rows = size(cnvs.image)[1]
	
	rows_per_unit = rows / y_span
	 
	
	x_span = cnvs.xR - cnvs.xL
	cols = size(cnvs.image)[2]
	
	cols_per_unit = cols / x_span 
	 
	
	abs(log(rows_per_unit / cols_per_unit)) < 0.005
end

# ╔═╡ 472f07be-0220-11eb-37c8-25f333681f1d
function pixel_to_rgb(cnvs::canvas, xy, rgb)
	row, col = row_col(cnvs, xy) 
	
	cnvs.image[row, col] = RGB(rgb[1], rgb[2], rgb[3])
end

# ╔═╡ b335c488-0221-11eb-3650-91434383480d
function pixel_to_color(cnvs::canvas, xy, clr)
	row, col = row_col(cnvs, xy) 
	
	cnvs.image[row, col] = clr
end

# ╔═╡ ba86af00-0225-11eb-2cfa-9d4f9c42017a
function line(cnvs::canvas, xy1, xy2, color)
	row1, col1 = row_col(cnvs, (xy1))
	row2, col2 = row_col(cnvs, (xy2))
	
	if abs(col2-col1) > abs(row2-row1)
		if col2 > col1
			col_hi = col2
			col_lo = col1
		else
			col_hi = col1
			col_lo = col2
		end
		
		for col in (col_lo : col_hi)
			x = x_coord(cnvs, col)
			y = y_from_line(xy1, xy2, x)
			row = row_num(cnvs::canvas, y)
			pixel_to_color(cnvs, (x, y), color)
		end
		
	else
		if row2 > row1
			row_hi = row2
			row_lo = row1
		else
			row_hi = row1
			row_lo = row2
		end
		
		for row in (row_lo : row_hi)
			y = y_coord(cnvs, row)
			x = x_from_line(xy1, xy2, y)
			col = col_num(cnvs::canvas, x)
			pixel_to_color(cnvs, (x, y), color)
		end
		
		
		
	end
	
end

# ╔═╡ Cell order:
# ╠═0be1266a-01bc-11eb-3a24-57c28ea50d21
# ╠═129e0e82-01bc-11eb-2142-91b9da370423
# ╠═3e8c8538-01bb-11eb-07d6-b573a23076b4
# ╠═a572eb02-01bb-11eb-0cf8-793120c966db
# ╠═e898fcd4-0236-11eb-2311-2365573a45bc
# ╠═1647195e-0237-11eb-09aa-55d2c9654798
# ╠═5f727268-0237-11eb-3ab8-bf67672322eb
# ╠═eb689b08-0237-11eb-372b-9f874134c5f1
# ╠═05748a66-0238-11eb-1952-978e7c91bcf4
# ╠═f3b33722-023a-11eb-2ecb-ed657c2b4ec5
# ╠═5c4c8cf4-023c-11eb-2b5c-152e7f8c9855
# ╟─233a6d88-01be-11eb-0cc2-f97d52d0af18
# ╠═86fb1a9a-022a-11eb-279a-65ffb8591362
# ╟─b5b4afea-022a-11eb-205a-559f25349798
# ╠═b0c2df32-0222-11eb-232d-b13654008d28
# ╠═b0ec43fe-0224-11eb-1849-c799b8999edc
# ╠═a8a8f63a-0225-11eb-33e6-6f9a47dfb94e
# ╠═26b0a1c2-022b-11eb-3ccf-b7735291e10a
# ╠═e9f3f53a-022b-11eb-1ba2-9b0e8f24a2d8
# ╠═ba86af00-0225-11eb-2cfa-9d4f9c42017a
# ╠═ceb8ad24-0230-11eb-3f5b-0d23a7cfd48b
# ╠═9594b112-021e-11eb-1563-ab181d629d29
# ╠═77b9e59a-021b-11eb-2c19-330fe7798797
# ╠═472f07be-0220-11eb-37c8-25f333681f1d
# ╠═b335c488-0221-11eb-3650-91434383480d
