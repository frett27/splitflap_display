



module HProfile(w, h, d, l, space)
{
	union()
	{
		cube([w + space*2, d + space*2, l], center = true);
		translate([-w/2+d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
		translate([+w/2-d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
	}
}
module UProfile(w, h, d, l, space)
{
	union()
	{
		translate([0,-h/2+d/2,0])cube([w + space*2, d + space*2, l], center = true);
		translate([-w/2+d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
		translate([+w/2-d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
	}
}
module LProfile(w, h, d, l, space)
{
	union()
	{
		translate([0,-h/2+d/2,0])cube([w + space*2, d + space*2, l], center = true);
		translate([-w/2+d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
	}
}
module OProfile(w, h, d, l, space)
{
	union()
	{
		translate([0,-h/2+d/2,0])cube([w + space*2, d + space*2, l], center = true);
		translate([0,+h/2-d/2,0])cube([w + space*2, d + space*2, l], center = true);
		translate([-w/2+d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
		translate([+w/2-d/2,0,0])cube([d + space*2, h + space*2, l], center = true);
	}
}
module TProfile(w, h, d, l, space)
{
	union()
	{
		translate([0,-h/2+d/2,0])cube([w + space*2, d + space*2, l], center = true);
		cube([d + space*2, h + space*2, l], center = true);
	}
}
module Tube(outerD, innerD, l, space)
{
	difference()
	{
		cylinder(h = l, r = outerD/2 + space, center = true);
		cylinder(h = l, r = innerD/2 - space, center = true);
	}
}

union()
{
	UProfile(w = 15, h = 15, d = 2, l = 100, space = 0);
	translate([20,0,0])
	HProfile(w = 15, h = 15, d = 2, l = 100, space = 0);
	translate([40,0,0])
	TProfile(w = 15, h = 15, d = 2, l = 100, space = 0);
	translate([60,0,0])
	OProfile(w = 15, h = 15, d = 2, l = 100, space = 0);
	translate([80,0,0])
	LProfile(w = 15, h = 15, d = 2, l = 100, space = 0);
	translate([100,0,0])
	Tube(outerD = 15, innerD = 11, l = 100, space = 0);
}
