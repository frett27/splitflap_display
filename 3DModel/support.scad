

// use <libraries/paratslot_for_openscad_201205/paratslot.scad>

include <digit_flip.scad>;


structure_height = 123;

bottom_support_height = 7;

sustain_structure_thick = 7;


angle = 40;



height_axis = 2*28byj48_shaft_offset;

main_structure_height = (structure_height * 2)/cos(angle);


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
    box(size=[42,sustain_structure_thick,main_structure_height],anchor=[0,-1,1]);
}



distance_to_support = 4; // mm from holes


// distance_to_support = 6; // mm from holes

module oblong(width=10, height=30, thick=2, class="oblong") {
    rod(d=width,h=thick, $class=class)
    box(size=[width,height,thick],anchor=[0,1,0], $class=class);
}


module _support_fixation_stator() {
        orient([0,1,0])
        differed("hole") {
                
                //
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
                translated(-(height_axis + skrew_hole_size /2 )*x)
                
                
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
    rotated( -angle *y)
    translated(offset_part * y) {
        difference() {    
            translated(28byj48_shaft_offset*z)
            {
                _support_fixation_stator();
                
                translated(distance_to_support*y)
                
                _support_pylon();

                
            };
            margin = 7;
            translated(distance_to_support*y - 0.01 * y)
            rotate([-90,0,0])
                   tube(d=diameter_flip + margin,
                            perfo=diameter_flip - margin,
                            h=2);
        
        }
    }


    dalle();
}

base_support_large = 60 + sustain_structure_thick;

module dalle() {
    // dalle
    base_support_width = 180;
    
    translated((offset_part 
                + distance_to_support 
                + sustain_structure_thick) * y
                -structure_height *z +
               (base_support_width / 2 - axe_external_diameter / 2) * x
               )
    box(size=[base_support_width, base_support_large ,          bottom_support_height], 
        anchor=[0,1,1]);
}




multiple_shift_position = base_support_large +2;
for( i = [0:3]) {
    
    translate([0, -(multiple_shift_position) * i,0]) {
            
        difference() {
         support();
         ground();
        }

        montage_g();
        rotor_g();
        stator_g();
        
    }
}

// rotor_g();
//stator_g();

//show the contact piece
/*
rotate([0,180,0])
translate([0,-10,0])
_stator_with_holding_hole();

*/


// show all other parts
//all();

