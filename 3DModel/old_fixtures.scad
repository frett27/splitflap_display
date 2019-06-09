

include <digit_flip.scad>

/////////////////////////////////////////////////////

// card fixture
fixture_height = 5;


module fixture() {
    cylinder(d = flip_fixure_diameter, h = 2);
    translate([-0.5,0,-1.5])
    box(size=[1,fixture_height,3]);
}

fixture_connector_size = 0.2;
module fixture_with_connect() {
    fixture();
    
    translate([-fixture_connector_size,fixture_height / 2,-fixture_connector_size])
    
    box(size=[fixture_connector_size,2*fixture_height,fixture_connector_size]);
    
    translate([-fixture_connector_size,0,fixture_height / 2 + 2])
    box(size=[fixture_connector_size,fixture_connector_size,fixture_height]);
    
    
}
fixture_with_connect() ;

// production function, to print multiple fixtures
module multiple_fixture_connected() {

   for (j= [0:5]) {
       for(i = [0:6]){
           translate([0,i* (fixture_height + fixture_height), j* (fixture_height + fixture_height)])
           fixture_with_connect();
           
       }
   }
    
}

// multiple_fixture_connected();




///////////////////////////////////////////////////////
//
// Mounting card facilities (
//
//

    mount_height = 1;
    mount_depth = flip_height;
    
    butee = 2;
    separate_butee = 0.4;
    mount_card_play = 0.4;
    mount_width = flip_width + 2 * butee + mount_card_play;

    support_flip_thick = 0.75;


module mounting_fixture_butee() {
    
     
    difference() {
        // traversial
        translate([-mount_width/2 + butee/2,
                  -mount_depth/2,
                  0])
        box(size=[butee,mount_depth,2*mount_height]);
        union() {
            // cute the elements for the card support
         
            translate([-mount_width/2 + butee ,
                  - deport + mount_card_play / 2,
                  0])
            box(size=[2 * butee, 
                    flip_fixure_diameter + mount_card_play, 
                    5 * mount_height]);
        }
    }
   
}

module _mounting_general_support() {
    
    translate([0,-mount_depth/2,- mount_height/2])
    box(size=[mount_width - 2 * butee,
              mount_depth,mount_height]);
    
    mounting_fixture_butee();
    mirror([y]) {
      mounting_fixture_butee();
    }
    
    translate([0,separate_butee/2, 0])
    union() {
        box(size=[mount_width,
                  separate_butee,
                  2 * mount_height]);
        
    }
    
}

module mounting_fixture() {
    
    difference() {
        union() {
                _mounting_general_support();
        }
        union() {
            
            translate([-(flip_width + mount_card_play)/2,
                       -deport,
                       0.1])
            rotate([0,-90,0])
            scale([1.03,1.03,1.03])
            fixture();
            
            mirror([y]) {
                translate([-(flip_width + mount_card_play)/2,
                           -deport,
                            0.1])
                rotate([0,-90,0])
                scale([1.02,1.02,1.02])
                fixture();
                
            }
        }
    }
    
    rotate([0,0,180]) {
        _mounting_general_support();
        
    }
        
}


module mounting_fixture_with_label() {
    difference() {
        mounting_fixture();        
        translate([-18,10,-0.2])        
        linear_extrude(height = 3) {
            text("flip flap card support", size=3);
        }        
    }
}




