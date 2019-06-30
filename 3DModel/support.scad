

// use <libraries/paratslot_for_openscad_201205/paratslot.scad>

include <digit_flip.scad>;


// distance from axis to base
structure_height = (flip_height - deport + radius_flip_position);

// echo (structure_height);

bottom_support_height = 7;

sustain_structure_thick = 7;


angle_pylon = 40;

height_axis = 2*28byj48_shaft_offset;

main_structure_height = (structure_height * 2)/cos(angle_pylon);


diameter_flip= 2 * radius_flip_position;




//$fa = 1;
//$fs=0.3;


////////////////////////////////////////////////////
//

module _support_pylon_real() {
    translate([-2 * sustain_structure_thick,0,0])
    for (i = [0:2]) {
        translate([i*14,0,0])
        translate([0,3.5,-main_structure_height/2])
        twotslot(h=structure_height,w=sustain_structure_thick);
    }
}

module _support_pylon() {
    
    pylon_width = 42;
    
    difference() { // for hole for the next axis
        
        union() {
            difference() {
               box(size=[pylon_width,sustain_structure_thick,      
                         main_structure_height],
                         anchor=[0,-1,1]);
            
               // cable pass
               depth = 6;
               mirror([1,0,0])
               union() {
                   // on the pylon side
                   translate([-pylon_width/2,
                                thick])
                   box(size= [depth, sustain_structure_thick - 2 * thick, 
                              main_structure_height],
                        anchor=[-1,-1,1]);
                   
                   // on the top to help guide the cables
                   rotate([0,-angle_pylon/2,0])// angle for passing cables
                   translate([0,thick,0])
                   box(size= [pylon_width, 
                          sustain_structure_thick - 2 * thick,
                          depth],
                        anchor=[0,-1,-1]);
                   
                   
               }
            }
            
            // upper support
            upper_pylon_width = sustain_structure_thick * 3 / 4;
            translate([0,
                       sustain_structure_thick - upper_pylon_width]) {
                d = pylon_width/4;
                
                
                    box(size=[d,
                              upper_pylon_width,
                              radius_flip_position ],
                        anchor=[1,-1,-1]);
                
                translate([0,0, radius_flip_position])
                rotate([0,angle_pylon,0])
                box(size=[d,
                          upper_pylon_width,
                          (flip_height - deport)*sin(45)], // angle
                    anchor=[1,-1,-1]);
                    
                translate([0,0, radius_flip_position])
                rotate([0,angle_pylon,0])
                box(size=[d,
                          upper_pylon_width,
                          main_structure_height],
                    anchor=[1,-1,1]);
                
            }
        }
        
            // hole for passing the next module axis
         hole_diameter = 28byj48_shaft_radius * 2 + play;
         translated(- 28byj48_shaft_offset*z 
                    + (sustain_structure_thick ) *y) 
                // for having the hole at 0
         orient(y)
         rod(d=hole_diameter, 
             h=sustain_structure_thick , 
             anchor=[0,0,0]);
    }
}

// _support_pylon();

top_distance = radius_flip_position + (flip_height - deport)*sin(45);
distance_to_support = 4; // mm from holes


// distance_to_support = 6; // mm from holes

module oblong(width=10, height=30, thick=2, class="oblong") {
    rod(d=width,h=thick, $class=class)
    box(size=[width,height,thick],anchor=[0,1,0], $class=class);
}


module _support_fixation_stator() {
        orient([0,1,0])
        differed("hole") {
                
                rod(h=thick, 
                d= 2 * 28byj48_mount_center_offset 
                    + skrew_hole_size +5 ,
                anchor =[0,0,-1])
                align([0,0,1])
                translated(5*y)
                box(size=[20,
                          10,
                          distance_to_support - thick],
                    anchor=[0,0,-1])
               
                 
                translated(-10*y)
                box(size=[50,50,50],$class="hole", 
                            anchor=[0,1,0]);
            
                // central    
                oblong(thick=90, 
                       width=10, 
                       class="hole");
                
                // trous        
                translated((height_axis + skrew_hole_size / 2)*x)
                oblong(width=skrew_hole_size,thick=90 , class="hole");
                translated(-(height_axis + skrew_hole_size /2)*x)
                
                
                oblong(width=skrew_hole_size,thick=90 , class="hole");
                
                
        }

}
// offset_part = 55;

// distance from center motor axis and the fixing
// plane
offset_part = 56.5;


module ground() {
    translated(- (structure_height + bottom_support_height) * z)
    box(size=[500,500,500],anchor=[0,0,1]);
}

module support() {
    rotated( -angle_pylon *y)
    translated(offset_part * y) {
        
        difference() {    
            translated(28byj48_shaft_offset*z)
            {
                _support_fixation_stator();
                
                translated(distance_to_support*y)
                
                _support_pylon();

                
            };
            
            // pin way
            union() {
                margin = 7;
                way_height = 2;
                
                // 1st way
                translated(distance_to_support*y - 0.01 * y)
                rotate([-90,0,0])
                tube(d=diameter_flip + margin,
                       perfo=diameter_flip - margin,
                       h=way_height);
                
                // 2nd way
                translated( (distance_to_support 
                             + sustain_structure_thick 
                            - way_height) * y)
                rotate([-90,0,0])
                tube(d=diameter_flip + margin,
                       perfo=diameter_flip - margin,
                       h=way_height + 0.1);
                
            }
        }
    }
    
    dalle_g();
}

// support();

base_support_width = 180;

module front_panels() {
    
     // bottom
     translated((offset_part 
                + distance_to_support 
                + sustain_structure_thick) * y
                -structure_height *z +
    
               -(base_support_width / 2 
                    - axe_external_diameter / 2 + thick) * x
               )
     box(size = [thick,base_support_large, 20 ], 
         anchor=[1,1,-1] );

     // up
     translated((offset_part 
                + distance_to_support 
                + sustain_structure_thick) * y
                + top_distance *z +
    
               -(base_support_width / 2 
                    - axe_external_diameter / 2 + thick) * x
               )
     box(size = [thick,base_support_large, 35 ], 
         anchor=[1,1,1] );


}

// support();

//front_panels();

base_support_large = 60 + sustain_structure_thick;

module dalle_g() {
   
    translated((offset_part 
                + distance_to_support 
                + sustain_structure_thick) * y
                -structure_height *z +
               (base_support_width / 2 - axe_external_diameter / 2) * x
               )
   dalle(); 
    
}

module dalle() {
    // dalle
    
    box(size=[base_support_width, base_support_large ,          bottom_support_height], 
        anchor=[0,1,1]);
    
}


///////////////////////////////////////////////////////////
// Assembly


module display_modules(number_of_modules = 6, margin = 2) {

    multiple_shift_position = base_support_large;
    for( i = [0:number_of_modules]) {
        
        translate([0, -(multiple_shift_position + margin) * i,0]) {
                
            difference() {
             support();
             ground();
            }
            
            axe_with_fix();
            montage_g();
            rotor_g();
            stator_g();
            front_panels();
            
        }
    }

}

/*
rotate([-90,0,0]) {
display_modules();
}
*/

module global_support() {
    difference() {
             support();
             ground();
            }
}


module cut_view() {

    difference() {
        
        display_modules(number_of_modules = 1, margin = 1);
        // cut to check
        translate([0,-10,0])
        cube(size=[1000,1000,1000]);
    }
}

/*
 // best view with stl viewer
rotate([-90,0,0])
cut_view();
*/


module exploded_view() {

    global_support()

    translate([0,-50,0])
    stator_motor_g();

    translate([0,-120,0])
    rotor_g();

    translate([0,-200,0])
    montage_g();

    translate([0,-250,0])
    axe_with_fix();            


}
// axe_with_fix();

//show the contact piece
/*
rotate([0,180,0])
translate([0,-10,0])
_stator_with_holding_hole();

*/


// show all other parts
//all();

