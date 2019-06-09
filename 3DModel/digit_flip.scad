

include <relativity.scad>
include <28byj-48.scad>
include <switch.scad>

////////////////////////////////////////////////////////////
//
//  Parameters for the design
//
////////////////////////////////////////////////////////////

// pvc card dimensions

pvc_card_width = 53.98;

// card support thick
support_flip_thick = 0.75;

flip_width = pvc_card_width + 2*support_flip_thick;
flip_height = 86.2/2; //2
flip_thick = 0.75;

flips_numbers = 12;
thick = 1.5;

// fixture size
flip_fixure_diameter = 2;

// play for the flip fixture, for rotating
flip_fixure_diameter_play = 1; // in diameter

// radius for flip rotating fix

/* initialement 42 */
radius_flip_position = 44; 
// flip axis distance
/* initialement 7.5 */
deport = 10;

// distance between the flip holes and external
margin_axe_external = 4;

// motor distance link
max_internal_radius = 42 /* radius_flip_position */ - 11;

// play for letting the elements move
// 0.2 is good
play = 0.2;


/////////////////////////////////
// internal generation parameters

angle_flip = 360/flips_numbers;
axe_external_diameter = 
                (radius_flip_position +
                 margin_axe_external) * 2;

// internal centring
internal_centring_elements_height = 2;

fixing_height = 28byj48_chassis_height + (flip_width - 28byj48_chassis_height) - 28byj48_shaft_height + 28byj48_shaft_slotted_height / 2;

// general animation angle parameters
general_rotation_angle = 0;

// drawing generation precision
// uncomment this for generating STL,
//

//$fa = 1;
//$fs=0.3;


module flip(width=flip_width) {
    // flip_fixure_diameter/2
    translate([0,0,0]) {
        
        translate([0,deport,0]) { // deport
            box(size=[width - 2 * support_flip_thick,
                        flip_height,
                        flip_thick],
                anchor=[0,1,1]);
        }


        // 1 
        translate([-width/2+support_flip_thick,0,0])
        rotate([0,180,0]) // flip to have the pin on proper direction
       
        rotate([0,0,90]) // orient along card
        translate([0,0, flip_thick / 2])
        support_flip_card_reference();
        
        translate([width/2 - support_flip_thick,0,0])
        
        rotate([0,0,90]) // orient along card
        translate([0,0, - flip_thick / 2])
        support_flip_card_reference();
                
    }
}


module axe() {
    
     rotate([0,general_rotation_angle,0]) {
            translated(thick/2 * y)
            orient([y])
            differed("hole")
            
            rod(d=axe_external_diameter ,h=thick)
            
            for (i = [0: flips_numbers]) {
                orient([z])
                rotated(angle_flip*i*z)
                translated(radius_flip_position  *x)
                rod(d=flip_fixure_diameter 
                       + flip_fixure_diameter_play,h=10, $class="hole");
            }
        };
}

module axe_with_holes() {
  
    difference() {
       
        union(){
            
          rotate([-90,0,0])
          rotate_extrude(convexity = 10)
          polygon(points = [
            [ (max_internal_radius) ,
               0],
            [  (max_internal_radius) ,
               3 * thick],
            [  (max_internal_radius - 2 * thick) ,
               3 * thick],
            
            [(max_internal_radius - 5 * thick) ,
               0]
          ]);
          axe();
            
          // pattes   
          
          for(i = [0:3]) {
              internal_radius = max_internal_radius;
              element_width = 10;
            
              rotated([0,90 * i,0])
              translate([0,element_width/2,-internal_radius])
              rotate([90,0,0])
              arc(rayon=internal_radius,
                  height=internal_centring_elements_height,
                  width=element_width, 
                  angle_start=-9, 
                  angle_end=9);

          }
            
          // axis tube
          
          rotate([90,0,0])
          translate([0,0,-thick])
          cylinder(d = 28byj48_shaft_radius * 3, h = thick);
            
        };
        
        // holes
        union() {
            
                // internal
                nb_internal = 6;
                for( i = [0:nb_internal]) {
                    rotate([0,i * 360/nb_internal +
                    general_rotation_angle,0])                    translate([12,10*thick,0]) 
                    rotate([90,0,0]) 
                    cylinder(d=8,h=20*thick);
                };
            
                for( i = [0:15]) {
                    rotate([0,i * 360/15 +
                        general_rotation_angle,0])                    translate([24,10*thick,0])
                    rotate([90,0,0])
                    cylinder(d=7,h=20*thick);
                };
        }
    }
    
   
    

}

// function to place flips with angle and index
module place_flip(index = 0, relative_angle = 0) {
     // second flip
    rotate([0, - index * angle_flip + general_rotation_angle ,0]) {
        translate([radius_flip_position,flip_width/2,0]) {
            rotate([0,
                    -90 + relative_angle 
                        - general_rotation_angle,
                    0]) {
                rotate([0,0,90]) {
           
                flip(width= flip_width);
             }
            }
        }
    }
}


// place the flips around the 12 holes design
module montage() {
    
    // one flip
    
    place_flip(0, relative_angle = 180);
    place_flip(1, relative_angle=180 - 15);
    place_flip(2, relative_angle=180 - 8);
    place_flip(3, relative_angle=180 - 8);
    place_flip(4, relative_angle=180 - 8);
    place_flip(5, relative_angle=180 - 8);
    place_flip(6, relative_angle=180 - 0);
    place_flip(7, relative_angle=angle_flip);
    
    place_flip(8, relative_angle=2 * angle_flip);
   
    place_flip(9, relative_angle=3 * angle_flip);

    place_flip(10, relative_angle=4 * angle_flip);

    place_flip(11, relative_angle=5 * angle_flip);
   
}

/*
// place the butee for the flip
module butee() {
    butee_width = flip_width + 2 * thick;
    translated( (flip_width * z) + 
            ( radius_flip_position + thick) * x - 
            2 * thick * z 
               )
    box(size = [2,butee_width,5],anchor=[-1,-1,-1]);
}
*/

// show motor
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

// utility tube module
module tube(d,h,perfo) {
    differed("trou","plein") {
     rod(d=d, h=h, $class="plein",anchor= [0,0,-1] );
     translate( [0,0,-1]) rod(d=perfo,h=h+2, anchor= [0,0,-1] , $class="trou");
 }
}


module threecircles(diameter=20, flips_numbers=5, height=thick) {
    
    rod(d=diameter, h=height);
    for(i = [0:360/flips_numbers:360]) {
        rotated([0,0,i])
        translated(diameter/2 * x)
        rod(d=diameter, h=height);    
    }
}

skrew_hole_size = 28byj48_mount_hole_radius * 2-1;

// stator module 
module stator() {
    
        
    fixing_base_radius = 28byj48_mount_hole_radius * 2 + thick;
 
    
    // fixation 1
     translated(28byj48_mount_center_offset * x - 28byj48_shaft_offset * z + 28byj48_mount_bracket_height *y )
    orient([y]) 
    tube(d=fixing_base_radius, h = fixing_height, perfo = skrew_hole_size);
    
    // renfort 1
    strength_size= 6;
    translated((28byj48_mount_center_offset + strength_size / 2 + 1) * x - 28byj48_shaft_offset * z + (28byj48_mount_bracket_height + fixing_height/2) *y ) 
    box(size=[strength_size,fixing_height,strength_size]);
    
    translated((28byj48_mount_center_offset) * x - (28byj48_shaft_offset + strength_size / 2 + 1) * z + (28byj48_mount_bracket_height + fixing_height/2) *y ) 
    box(size=[strength_size,fixing_height,strength_size]);
    
    translated((28byj48_mount_center_offset) * x - (28byj48_shaft_offset - strength_size / 2 - 1) * z + (28byj48_mount_bracket_height + fixing_height/2) *y ) 
    box(size=[strength_size,fixing_height,strength_size]);
    
    
    
    // fixation 2
    
    mirror([x]) {
        translated(28byj48_mount_center_offset * x - 28byj48_shaft_offset * z + 28byj48_mount_bracket_height *y )
        orient([y]) tube(d=fixing_base_radius, h = fixing_height, perfo = skrew_hole_size);
    
         translated((28byj48_mount_center_offset + strength_size / 2 + 1) * x - 28byj48_shaft_offset * z + (28byj48_mount_bracket_height + fixing_height/2) *y ) 
    box(size=[strength_size,fixing_height,strength_size]);
    
    translated((28byj48_mount_center_offset) * x - (28byj48_shaft_offset + strength_size / 2 + 1) * z + (28byj48_mount_bracket_height + fixing_height/2) *y ) 
    box(size=[strength_size,fixing_height,strength_size]);
    
         translated((28byj48_mount_center_offset) * x - (28byj48_shaft_offset - strength_size / 2 - 1) * z + (28byj48_mount_bracket_height + fixing_height/2) *y ) 
    box(size=[strength_size,fixing_height,strength_size]);
    
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
        translated(- (28byj48_shaft_offset - height_difference/2 -1 ) * z
                   + (fixing_height - height_renfort/2 + space/2)   * y + 
                   5 * x)
        box(size= [6,
                   height_renfort - space,
                   26 + height_difference]);
        translated(- (28byj48_shaft_offset - height_difference/2 ) * z
                   + (fixing_height - height_renfort/2 + space/2)   * y + 
                   - 6 * x)
        box(size= [6,
                   height_renfort - space,
                   26 + height_difference]);
    
    // back support
    translated((28byj48_mount_bracket_height + fixing_height) *y ) {
        backthick = 3 * thick;
        translated( - backthick / 2 *y )
        orient([y])
        {
            rotate([0,0,30])
            threecircles(diameter=max_internal_radius, 
                         flips_numbers=3,
                        height=backthick);
        };
    }
    
}


module _fixing_stator_holes() {
    
      
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

module _stator_with_holding_hole() {
    
    differed("hole") {
        stator();
        
        // cable pass
        height_renfort = fixing_height - 28byj48_chassis_height;
        space = 5;
        
        translated( - 28byj48_shaft_offset * z
         + (fixing_height - height_renfort/2 + space/2)   * y 
        )
        rotate([0,90 + 45,0])
        translated( - 4 * z + 10*y)
        box(size=[2,10,500], anchor=[1,0,1], $class="hole");
        
        translated( - 28byj48_shaft_offset * z
         + (fixing_height - height_renfort/2 + space/2)   * y 
        )
        rotate([0,180 + 45,0])
        translated( - 4 * z + 10*y)
        box(size=[2,10,500], anchor=[1,0,1], $class="hole");
        
        
         
        // central hole
        translated(
                    + fixing_height * y)
        orient([y])
        rod( d=11, h=8, $class="hole");
        
        
        // back hole
        translated( - 28byj48_shaft_offset * z
                    + fixing_height * y)
        orient([y])
        rod( d=11, h=8, $class="hole");
      
        _fixing_stator_holes();
        
    }
    
}

module stator_with_holding_hole() {
    
    difference() {
        _stator_with_holding_hole();
        
        // body of switch
        
        union() {
            switch_placement();
            // space for connectors
            switch_space();
        }
        
    }
    
    
}



//stator_with_holding_hole();
//switch_placement();
//rotor();

///////////////////////////////////////////////////////



module arc(rayon,height,width,angle_start, angle_end) {
    
    center = [ 0, rayon ];
    _max = angle_end;
    _min =angle_start;
    poly_points = [ for(i = [_min:_max]) 
       rayon * [ cos(i + 270),sin(i + 270) ] + center 
    ];

    o = [ (rayon - height) * [ cos(_max + 270),sin(_max + 270) ] + center ];

    o2 = [ for(i = [_max:-1:_min]) 
       (rayon - height) * [ cos(i + 270),sin(i + 270) ] + center 
    ];
    
    linear_extrude(height = width, center = true, twist = 0) 
    polygon(points = concat(poly_points, o, o2));
}

module demi_patte(angle, internal_centring_elements_height=internal_centring_elements_height) {
     
    internal_radius = (max_internal_radius + play);
    
    element_width = 10;
    translate([0,element_width/2,-internal_radius])
    rotate([90,0,0])
    arc(rayon=internal_radius,height=internal_centring_elements_height,width=element_width, angle_start=angle, angle_end=angle + 20);

    
}


module arc_ramp(rayon,height,width,angle_start, angle_end) {

    center = [ 0, rayon ];
    _max = angle_end;
    _min =angle_start;
    
    ramp_size_factor = 2;
   
    poly_points = [ for(i = [_min:_max]) 
       rayon * [ cos(i + 270),sin(i + 270) ] + center 
    ];
    o2 = [ for(i = [_max - ( (_max-_min) /ramp_size_factor):-0.3: _min ]) 
       (rayon - height) * [ cos(i + 270),sin(i + 270) ] + center 
    ];
    
    linear_extrude(height = width, center = true, twist = 0) 
    polygon(points = concat(poly_points, o2));

}

module homing_pos(angle, internal_centring_elements_height=internal_centring_elements_height) {
     
    internal_radius = (max_internal_radius + play);
    
    element_width = 10;
    translate([0,element_width/2,-internal_radius])
    rotate([90,0,0])
    arc_ramp(rayon=internal_radius,height=internal_centring_elements_height,width=element_width, angle_start=angle, angle_end=angle + 40);

    homing_pos_ramp(angle, offset=element_width,internal_centring_elements_height = internal_centring_elements_height);
    
}

module homing_pos_ramp(angle, offset=0, width = 10, internal_centring_elements_height=internal_centring_elements_height) {
     
    internal_radius = (max_internal_radius + play);
    
    element_width = 10;
    step = 0.25;
    for (i = [0:step:width]) {
        translate([0,offset + i,-internal_radius])
        rotate([90,0,0])
        arc_ramp(rayon=internal_radius,
                 height=internal_centring_elements_height/width * (width - i),
                 width= step,
                 angle_start=angle, 
                 angle_end=angle + 40);
    }
}

module patte() {
    demi_patte(10);
    demi_patte(-30);
}


module rotor() {

    racc = 2;
    
    tube_height = (flip_width + 2 * play + thick);
    
    orient([y]) {
    tube(d=(max_internal_radius + thick + play) * 2,
         h=tube_height,
         perfo=(max_internal_radius + play) * 2); 
    }
    
   
    
    differed("hole") {
        
        translate([0, tube_height - thick,0]) {
            // reference of axe is 
            axe();
        }
        
        
        // hardening tube / end
        hull() {
        orient([y]) {
            translated(  (tube_height - thick - racc) * z )
            tube(d=(max_internal_radius + thick) * 2,
                 h=0.1,
                 perfo=2 * max_internal_radius + 2 * play); 
            
            translated(  (tube_height -thick ) * z )
            tube(d=(max_internal_radius + thick + racc) * 2,
                 h=0.1,
                 perfo=2 * max_internal_radius + 2 * play); 
            }
        }
        
        
        orient([y])
        translated( (tube_height - play) * z) {
        rod(d = (max_internal_radius + play) * 2,
           h = 30,
           $class="hole");
        }
        
    }
    
    // positionning elements inside
    for (i = [0:3]) {
        rotate([0, i * 90, 0])
        translate([0,6,0])
        patte();
    }
    
     // patte
    translate([0,fixing_height - 24])
    homing_pos(angle=-120, internal_centring_elements_height = 3);


}

module axe_with_fix() {
    difference() {
        axe_with_holes();
        
        translate([0,
                   28byj48_shaft_height 
                      - 28byj48_shaft_slotted_height / 2,
                   0 ]) { 
            rotate ([90,0,0]) Stepper28BYJ48();
        }
    }
    
}

/////////////////////////////////////////////////////
// external box

// function for creating an empty box, width no content
// inside
module empty_box(width, depth, height, ethick, play) {
    
    translate([-depth/2 - play,-ethick - play, -height/2 - play])
    difference() {
        translate([-ethick, -ethick, -ethick])
        cube(size = [depth+2*ethick + 2*play, 
                     width+2*thick + 2*play,
                     height + 2*ethick + 2*play]);
        
        cube(size = [depth+ 2*play, 
                     width+ 2*play, 
                     height+ 2*play]);
    }
}

//
// external container of the flip box
//
module external_box() {
    
    // back depth margin
    back_margin = flip_height / 2;
    
   
    depth = axe_external_diameter + back_margin;
    width = flip_width + 4 * thick;
    height = 2 * (flip_height - deport + radius_flip_position);
    
    height_deport = flip_height / 4;
    
    // window
    window_height = 2 * flip_height;
    butee_size = 5;
    
    // window for the digits
    echo("depth=",depth,"width=", width,"height=", height);
    difference() {
        translate([( back_margin)/2,
                    0,
                    -height_deport])
        empty_box(width=width, 
                depth=depth, 
                height=height, 
                ethick = thick, 
                play=1);
        
       
        translate([-2/3*depth,
                   -thick,
                    - window_height + 
                    flip_height 
                    - deport - butee_size]) 
        cube([depth,width,window_height]);
    }
    
    // Electronic box
    ebox_height = 30;
    ebox_depth = 40;
    translate([- (back_margin - depth /2 - ebox_depth/2)   ,
               width/2, 
                -depth +  ebox_height/2 + flip_height/2 ])
    box(size=[ebox_depth,width , ebox_height]);
    
}




/////////////////////////////////////////////
// switch 

swith_offset_position_in_material = 14.8;

module switch_position() 
{
    translate([-6, fixing_height - swith_offset_position_in_material,-5])
    rotate([0,-40,0])
    
    rotate([90,0,0])
    
    
    switch(angle=switch_angle1, drawboth = 1);
    
}

module switch_space() {
     
    // place switch
    // todo, refactor

    l = switch_width/2;
    h = switch_height + 7;
    
    translate([-4, fixing_height - swith_offset_position_in_material,-8])
    rotate([0,-40,0])
    rotate([90,0,0])
    translate([l,h/2,switch_deep/2])
    scale([1.01,1.01,1.01])
    box(size=[l, h, switch_deep]);
    
}

module switch_placement() {
    
    // place switch
    // todo, refactor

    translate([-6, fixing_height - swith_offset_position_in_material,-5])
    rotate([0,-40,0])
    
    rotate([90,0,0])
    
    translate([switch_width/2,switch_height/2,switch_deep/2])
    scale([1.01,1.01,1.01])
    switch_body_centered(angle=switch_angle1, drawboth = 1);
    
}



/////////////////////////////////////////////////
// Fixtures

    mount_height = 1;
    mount_depth = flip_height;
    
    butee = 2;
    separate_butee = 0.4;
    mount_card_play = 0.4;
    mount_width = flip_width + 2 * butee + mount_card_play;



// flip support for reference on card contact inside
module support_flip_card_reference() {
    translate([0, -support_flip_thick , 0] ) 
    support_flip();
}


// this module create the card insert support
module support_flip() {
    
    // height of support
    // should be more than flip width
    height = 3;
    // height along the card
    support_height = 30;
    // fixture length
    pico_length = 3;
    
    difference () {
        translate([-support_height + deport,0,-height/2])
        cube(size=[support_height,height,height]);
    
           
        union() {
            // card cut
            translate([-support_height+ deport,
                       support_flip_thick,
            -flip_thick/2])
            cube(size=[40,10,flip_thick]);
            
            // champfer
            translate([deport ,0,0])
            translate([0,height,0])
            rotate([0,0,-45])
            box(size=[height,height * 3, height],
                anchor=[-1,0,0]);
        }
    }
    
    // pico
    translate([0,-pico_length/2,0])
    orient([y])
    rod(d=flip_fixure_diameter, h=pico_length);
}

//support_flip();

module multiple_support_flip() {
    for (i = [0: flips_numbers * 2]) {

        translate([0,5*i,0])
        rotate([-90,0,0])
        support_flip();

    }

}



/////////////////////////////////////////////////////
// General module

module rotor_g() {
     translated( thick * y)
        rotor();
    
}

module stator_g() {
     translate([0,28byj48_shaft_height 
                    - 28byj48_shaft_slotted_height / 2,0 ]) { 
        rotate ([90,0,0]) Stepper28BYJ48();
        color("red") {
            stator_with_holding_hole();
        }
    }
    
}

module montage_g() {
    color("white") {
        translate([0,thick + play, 0])
        // all flips
        montage();
    }
}

montage_g();
rotor_g();


module all() {
 
    axe_with_fix();
    
    montage_g();
    
    stator_g();
   
    color("blue") {
       rotor_g();
    }
     
    
}

// all();

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
  
  // translate([-250,25,-250]) cube(size=[500,500,500]);
  translate([-250,-500 + 25,-250]) cube(size=[500,500,500]);
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

//all();

/////////////////////////////////////////
// details of every parts

// mounting_fixture_with_label();

//rotate([0,90,0])

//rotor();
//stator_with_holding_hole();

//switch_position();
// axe_with_fix();
