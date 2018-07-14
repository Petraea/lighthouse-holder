use <MCAD/nuts_and_bolts.scad>;
$fn=50;
shim=0.01;
module lighthouse(dims=[100,100,100],curve_radius=10,shim=0.01,cable_edge=8,screw_offset=15) {
  inner_dims=[dims[0]-curve_radius*2,
               dims[1],
               dims[2]-curve_radius*2];
//  translate([0,0,dims[2]/2])
  union () {
    minkowski() {
      rotate([90,0,0])
        cylinder(h=shim/2,r=curve_radius, center=true);
      cube(inner_dims, center=true);
    }
  translate([0,dims[1]/2,-dims[2]*0.25]) cube([dims[0]-cable_edge*2,dims[1],dims[2]/2-cable_edge*2],center=true); //Cable clearance
  translate([0,dims[1]/2,screw_offset]) rotate([90,0,0]) cylinder(r=6.5/2,h=40,center=true); //Screw hole
  }
}

module lighthouse_holder(top=true) {
  difference() {
    union () {
      difference() {
        cube([105,105,105],center=true);
        cube([85,85,125],center=true);
        cube([85,125,85],center=true);
//        translate([0,0,30]) cube([125,85,25],center=true);
//        translate([0,0,-30]) cube([125,85,25],center=true);
      }
    difference() {
      cube([135,30,35],center=true);
      //Cornering for printer
      translate([86,0,-20]) rotate([0,45,0]) cube([50,50,50],center=true);
      translate([-86,0,-20]) rotate([0,45,0]) cube([50,50,50],center=true);
      translate([86,0,20]) rotate([0,45,0]) cube([50,50,50],center=true);
      translate([-86,0,20]) rotate([0,45,0]) cube([50,50,50],center=true);
      //Top and bottom screws
      translate([-58,0,-5]) nutHole(size=4,tolerance=0.2);
      translate([-58,0,-14.5]) cylinder(h=20,r=5.5,center=true);
      translate([-58,0,2]) rotate([180,0,0]) boltHole(size=4,length=15,tolerance=1);
      translate([-58,0,12]) cylinder(h=20,r=5.5,center=true);
      translate([58,0,2]) nutHole(size=4,tolerance=0.2);
      translate([58,0,14.5]) cylinder(h=20,r=5.5,center=true);
      translate([58,0,-2]) boltHole(size=4,length=15,tolerance=1);
      translate([58,0,-12]) cylinder(h=20,r=5.5,center=true);
      //Side screws
      translate([-65,0,0]) rotate([0,90,0]) nutHole(size=4,tolerance=0.2);
      translate([-77,0,0]) rotate([0,90,0]) boltHole(size=4,length=15,tolerance=0.5);
      translate([65,0,0]) rotate([0,-90,0]) nutHole(size=4,tolerance=0.2);
      translate([77,0,0]) rotate([0,-90,0]) boltHole(size=4,length=15,tolerance=0.5);
    }
    }
    if (top) {
      translate([0,0,-100])cube([200,200,200],center=true);
    } else {
      translate([0,0,100])cube([200,200,200],center=true);
    }
    lighthouse(shim=shim);
  }
}

module base() {
    //Foot to screw to the wall
    //Rotation point w/ captive nut
  difference () {
    hull() {
        translate([0,0,0]) cylinder(h=10,d=20);
        translate([15,30,0]) cylinder(h=5,d=15);
        translate([15,-30,0]) cylinder(h=5,d=15);
        translate([-15,30,0]) cylinder(h=5,d=15);
        translate([-15,-30,0]) cylinder(h=5,d=15);
    }
    translate([0,0,-0.05]) rotate([0,0,0]) nutHole(size=8,tolerance=0.2);
    translate([0,0,15]) rotate([180,0,0]) boltHole(size=8,length=15,tolerance=1);
    translate([15,30,15]) rotate([180,0,0]) boltHole(size=4,length=18,tolerance=0.5);
    translate([15,-30,15]) rotate([180,0,0]) boltHole(size=4,length=18,tolerance=0.5);
    translate([-15,30,15]) rotate([180,0,0]) boltHole(size=4,length=18,tolerance=0.5);
    translate([-15,-30,15]) rotate([180,0,0]) boltHole(size=4,length=18,tolerance=0.5);
  }
}

module fork() {
  difference() {
    translate([0,0,42]) cube([146,20,100],center=true);
    translate([0,0,0]) cube([69*2,30,76*2+10],center=true);
    translate([0,0,69+15]) rotate([0,0,0]) boltHole(size=8,length=15,tolerance=1);
    //Connector between base and holder
    //bolt hole for base and bolts for holder
    translate([-77,0,0]) rotate([0,90,0]) boltHole(size=4,length=15,tolerance=0.5);
    translate([77,0,0]) rotate([0,-90,0]) boltHole(size=4,length=15,tolerance=0.5);
  }
}

module view(t=0,y=0) {
  translate([0,0,103]) rotate([180,0,0]) base();
  rotate([0,0,y]) {
    rotate([-t,0,0]) translate([0,0,0.005]) lighthouse_holder(true);
    rotate([-t,0,0]) translate([0,0,-0.005]) lighthouse_holder(false);
    fork();
  }
}

module print() {
  translate([130,0,52.5]) rotate([180,0,90]) lighthouse_holder(true);
  translate([0,0,52.5]) rotate([0,0,90]) lighthouse_holder(false);
  translate([0,0,10]) rotate([90,0,0]) fork();
  translate([0,0,0]) rotate([0,0,0]) base();
  translate([0,0,0]) rotate([0,0,0]) base();
}

view(45,45);
