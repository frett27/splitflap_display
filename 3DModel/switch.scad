
include <relativity.scad>


inter_axes = 24.45;
switch_angle0 = atan(9.41/inter_axes);
switch_angle1 = atan(4.61/inter_axes);

switch_width = 28.2;
switch_height = 16;
switch_deep = 9.70;



module target(angle) {
    
    
}

// hole 1.5 du bord
switch_holes_size = 3;
switch_edge_distance = 1.3;

module switch_holes(d=switch_holes_size, h = 10) {
      // 3mm
        translate([ d/2 + switch_edge_distance,
                    d/2 + switch_edge_distance,
                    0])
        cylinder(d=d,h=h);
        
        translate([switch_width - (d/2 + switch_edge_distance), 
                  switch_height - (d/2 + switch_edge_distance),
                  0])
        cylinder(d=d,h=h);
    
}

module switch_body() {

    difference() {
        translate([ +switch_width/2,
                    switch_height/2,
                    switch_deep/2])
        switch_body_centered()
        //cube(size=[switch_width, switch_height, switch_deep]);
        switch_holes();
    }
}

module switch_body_centered() {
    box(size=[switch_width, switch_height, switch_deep]);
}

module switch(angle = switch_angle0, drawboth=0) {
    
    switch_body();

    // axe
    t_width = 0.6;
    t_large = 4.4;
    h_axe = 2.5;

    inter_axes = 24.45;
    /// boule en bout
    touch_diameter=4.77;
    touch_large = 4.4;

    if (drawboth == 1) {
            
        translate([-t_width/2 + switch_width/2,switch_height - h_axe,switch_deep/2])
        rotate([0,0,90 - switch_angle0])
        box([t_width,inter_axes,t_large], anchor=[0,-1,0])
        align([0,1,0])
        rod(d=touch_diameter, h=touch_large, anchor=[0,0,0]);


        translate([-t_width/2 + switch_width/2,switch_height - h_axe,switch_deep/2])
        rotate([0,0,90 - switch_angle1])
        box([t_width,inter_axes,t_large], anchor=[0,-1,0])
        align([0,1,0])
        rod(d=touch_diameter, h=touch_large, anchor=[0,0,0]);

            
        
        
    } else {
            
        translate([ -t_width/2 + switch_width/2,
                    switch_height - h_axe,
                    switch_deep/2])
        rotate([0,0,90 - angle])
        box([t_width,inter_axes,t_large], anchor=[0,-1,0])
        align([0,1,0])
        rod(d=touch_diameter, h=touch_large, anchor=[0,0,0]);
    }
}

// switch();

// place connexions 

