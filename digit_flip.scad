
include <relativity.scad>



// pvc card dimensions

flip_width = 53.98;
flip_height = 86.2 / 2;

nbtrou = 12;
thick = 1.5;
flip_fixure_diameter = 2;


// radius for flip 
// 
diameter_flip = 40;
// flip axis distance
deport = 7;

// distance between the flip holes and external
margin_axe_external = 4;

// motor distance link
max_internal_radius = diameter_flip - 10;

play = 0.5;


/////////////////////////////////
// internal generation parameters

angle_flip = 360/nbtrou;
axe_external_diameter = 
                (diameter_flip +
                 margin_axe_external) * 2;

// general animation parameters
general_rotation_angle = 0;

// drawing generation precision
// uncomment this for generating STL,
//
//k$fa = 1;
//$fs=0.3;

module flip(width=30) {
    
    translate([0,flip_fixure_diameter/2,0]) {
        
        translate([0,deport,0]) { // deport
            box(size=[width,flip_height,thick],
                anchor=[0,1,1]);
        }
        
        mirrored([x])
        translated(width/2*x)
        align([x])
        orient([1,0,0])        
        rod(d=flip_fixure_diameter,h=5, anchor=[0,1,0]);
    
    }
}

module axe() {
    
     rotate([0,general_rotation_angle,0]) {
            
            orient([y])
            differed("hole")
            rod(d=axe_external_diameter ,h=thick)
            
            for (i = [0: nbtrou]) {
                orient([z])
                rotated(angle_flip*i*z)
                translated(diameter_flip  *x)
                rod(d=flip_fixure_diameter 
                       + 2*play,h=10, $class="hole");
            }
        };
}

module axe_with_holes() {
    
    difference() {
       
        axe();
        // holes
        union() {
                for( i = [0:5]) {
                    rotate([0,i * 360/5 +
                    general_rotation_angle,0])                    translate([12,thick,0]) 
                    rotate([90,0,0]) 
                    cylinder(d=10,h=2*thick);
                };
            
                for( i = [0:15]) {
                    rotate([0,i * 360/15 +
                        general_rotation_angle,0])                    translate([24,thick,0])
                    rotate([90,0,0])
                    cylinder(d=7,h=2*thick);
                };
        }
    }
    
    orient([y])
    translated(thick*z)
    tube(d=(max_internal_radius) * 2 ,
         h=thick,
         perfo=(max_internal_radius - thick) * 2);

}


module place_flip(index = 0, relative_angle = 0) {
     // second flip
    rotate([0, - index * angle_flip + general_rotation_angle ,0]) {
        translate([diameter_flip,flip_width/2 + thick,0]) {
            rotate([0,-90 + relative_angle - general_rotation_angle,0]) {
                rotate([0,0,90]) {
           
                flip(width= flip_width);
             }
            }
        }
    }
}



module montage() {
    
    // one flip
    
    place_flip(0);
    place_flip(1, relative_angle=15);
    place_flip(2, relative_angle=8);
    place_flip(3, relative_angle=8);
    place_flip(4, relative_angle=8);
    place_flip(5, relative_angle=8);
    place_flip(6, relative_angle=0);
    place_flip(7, relative_angle=angle_flip);
    
    place_flip(8, relative_angle=2 * angle_flip);
   
    place_flip(9, relative_angle=3 * angle_flip);

    place_flip(10, relative_angle=4 * angle_flip);

    place_flip(11, relative_angle=5 * angle_flip);
   
}

module butee() {
    butee_width = flip_width + 2 * thick;
    translated( (flip_width * z) + 
            ( diameter_flip + thick) * x - 
            2 * thick * z 
               )
    box(size = [2,butee_width,5],anchor=[-1,-1,-1]);
}


module motor() {
    differed("bords") {
        
        rod(d = 20, h = 25,anchor=[0,0,1])
        align([0,0,1]) {
            rod(d = 2, h=8.1);
        
            translated((20/2 + 15.1/2) * x + -30 * z) 
            box(size=[20, 30, 30], $class="bords");

            rotated(180*z)
            translated((20/2 + 15.1/2) * x + -30 * z) 
            box(size=[20, 30, 30], $class="bords");
        }
    };
}

include <28byj-48.scad>

// utility tube module
module tube(d,h,perfo) {
    differed("trou","plein") {
     rod(d=d, h=h, $class="plein",anchor= [0,0,-1] );
     translate( [0,0,-1]) rod(d=perfo,h=h+2, anchor= [0,0,-1] , $class="trou");
 }
}




module rosace(diameter=20, nbtrou=5) {
    
    rod(d=diameter, h=thick);
    for(i = [0:360/nbtrou:360]) {
        rotated([0,0,i])
        translated(diameter/2 * x)
        rod(d=diameter, h=thick);    
    }
}

skrew_hole_size = 28byj48_mount_hole_radius * 2-2;

module stator() {
    
        
    fixing_base_radius = 28byj48_mount_hole_radius * 2 + thick;
    fixing_height = 28byj48_chassis_height + (flip_width - 28byj48_chassis_height) - 28byj48_shaft_height + 28byj48_shaft_slotted_height / 2;
    
    // fixation 1
     translated(28byj48_mount_center_offset * x - 28byj48_shaft_offset * z + 28byj48_mount_bracket_height *y )
        orient([y]) tube(d=fixing_base_radius, h = fixing_height, perfo = skrew_hole_size);
    
    
    // fixation 2
    
    mirror([x]) {
        translated(28byj48_mount_center_offset * x - 28byj48_shaft_offset * z + 28byj48_mount_bracket_height *y )
        
        orient([y]) tube(d=fixing_base_radius, h = fixing_height, perfo = skrew_hole_size);
    
    };
    
    
    height_renfort = fixing_height - 28byj48_chassis_height;
    space = 5;
    translated(- 28byj48_shaft_offset * z
               + (fixing_height - height_renfort/2 + space/2)   * y)
    box(size= [28byj48_mount_center_offset * 2,
               height_renfort - space,
               fixing_base_radius]);
    
    // strong piece
    // height strong difference height
    height_difference = 20;
    translated(- (28byj48_shaft_offset - height_difference/2) * z
               + (fixing_height - height_renfort/2 + space/2)   * y)
    box(size= [3,
               height_renfort - space,
               20 + height_difference]);
    
    
    
    // back support
    translated((28byj48_mount_bracket_height + fixing_height) *y ) {
        
        orient([y])
        {
            rotate([0,0,30])
            rosace(diameter=max_internal_radius, nbtrou=3);
        };
            
       /*     
        hull() {
            translated(28byj48_mount_center_offset * x 
                       - 28byj48_shaft_offset * z +
                       28byj48_mount_bracket_height *y)
                
            orient([y]) 
            rod(d=fixing_base_radius * 2, 
                h=thick);
                
            translated(- 28byj48_mount_center_offset * x 
                       - 28byj48_shaft_offset * z 
                       + 28byj48_mount_bracket_height *y)
                
            orient([y]) 
            rod(d=fixing_base_radius * 2,
                h=thick);
            
           
        }*/
    }
    
}

module stator_with_holding_hole() {
     fixing_height = 28byj48_chassis_height + (flip_width - 28byj48_chassis_height) - 28byj48_shaft_height + 28byj48_shaft_slotted_height / 2;
    
    differed("hole") {
        stator();
        
        // cable pass
        translated( - 28byj48_shaft_offset * z)
        rotate([0,90 + 45,0])
        translated( - 4 * z )
        box(size=[3,1000,500], anchor=[1,0,1], $class="hole");
        
        // back hole
        translated( - 28byj48_shaft_offset * z
                    + fixing_height * y)
        orient([y])
        rod( d=11, h=8, $class="hole");
        
        // fixing holes, for skrews
        // 1
        translated( - 28byj48_shaft_offset * z
                + 28byj48_mount_center_offset * x
                + fixing_height * y)
        orient([y])
        rod( d=skrew_hole_size, h=10, $class="hole");
        // 2
        translated( - 28byj48_shaft_offset * z
                - 28byj48_mount_center_offset * x
                + fixing_height * y)
        orient([y])
        rod( d=skrew_hole_size, h=10, $class="hole");
        
        
    }
    
}


module second_axe() {
  
    translate([0, flip_width + 2*thick,0]) {
        axe();
    }
}

module rotor() {

    racc = 2;
    orient([y]) {
    tube(d=(max_internal_radius + thick) * 2,
         h=(flip_width + play + 2 *thick),
         perfo=2 * max_internal_radius + 2 * play); 
    }
    
   
    
    differed("hole") {
        second_axe();
        
        
        hull() {
        orient([y]) {
            translated(  (flip_width + 2*thick - racc) * z )
            tube(d=(max_internal_radius + thick) * 2,
                 h=0.1,
                 perfo=2 * max_internal_radius + 2 * play); 
            
            translated(  (flip_width + 2*thick) * z )
            tube(d=(max_internal_radius + thick + racc) * 2,
                 h=0.1,
                 perfo=2 * max_internal_radius + 2 * play); 
            }
        }
        
        orient([y])
        translated( (flip_width + 2*thick) * z) {
        rod(d = (max_internal_radius + thick) * 2,
           h = 30,
           $class="hole");
        }
    }
}

module axe_with_fix() {
    difference() {
        axe_with_holes();
        
        translate([0,28byj48_shaft_height - 28byj48_shaft_slotted_height / 2,0 ]) { 
            rotate ([90,0,0]) Stepper28BYJ48();
        }
    }
    
}

/////////////////////////////////////////////////////
// external box

module empty_box(width, depth, height, ethick, play) {
    
    translate([-depth/2 - play,-ethick - play, -height/2 - play])
    difference() {
        translate([-ethick, -ethick, -ethick])
        cube(size = [depth+2*ethick + 2*play, 
                     width+2*thick + 2*play,
                     height + 2*ethick + 2*play]);
        
        cube(size = [depth+ 2*play, width+ 2*play, height+ 2*play]);
    }
}

module external_box() {
    
    // back depth margin
    back_margin = flip_height / 2;
    
    depth = axe_external_diameter + back_margin;
    width = flip_width + 4 * thick;
    
    height = 2 * (flip_height - deport + diameter_flip);
    
    // window
    window_height = 2 * flip_height;
    butee_size = 5;
    
    echo("depth=",depth,"width=", width,"height=", height);
    difference() {
        translate([(- back_margin)/2,
                    0,
                    - flip_height/3])
        empty_box(width=width, 
                depth=depth, 
                height=height, 
                ethick = thick, 
                play=1);
        
       
        translate([0,
                   -thick,
                    - window_height + 
                    flip_height 
                    - deport - butee_size]) 
        cube([1000,width,window_height]);
    }
}


/////////////////////////////////////////////////////
// General module

module all() {
 
    axe_with_fix();
   
    color("white") {
        montage();
    }
    translate([0,28byj48_shaft_height - 28byj48_shaft_slotted_height / 2,0 ]) { 
        rotate ([90,0,0]) Stepper28BYJ48();
        color("red") {
            stator_with_holding_hole();
        }
    
    }
   
     color("blue") {
        rotor();
     }
    
}

/////////////////////////////////////////////

/*
difference() {
    
    union() {
     all();
     external_box();
    }
    
    translate([-250,flip_width / 2,-250]) cube(size=[500,500,500]);
}
*/

/*
difference() {

 all();
  
 translate([0,25,0]) cube(size=[50,500,500]);

}    
*/

 
 
/*
 translate([0,28byj48_shaft_height - 28byj48_shaft_slotted_height / 2,0 ]) { 
        rotate ([90,0,0]) Stepper28BYJ48();
        color("red") {
            stator_with_holding_hole();
        }
    
    }
*/

rotor();