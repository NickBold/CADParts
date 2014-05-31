function rVac() = ((99.36)/2)+1;
function hVac() = 38;
function rCNC() = ((58.76)/2)+1;
function hCNC() = 70;
function wNub() = 18.16+1;
function hNub() = 32.84;

module cylVAC(){
	cylinder(h=hVac(),r=rVac(),center=false);
}
module cylCNC(){
	cylinder(h=hCNC(),r=rCNC(),center=false);
}

module cylMid(){
	cylinder(h=50,r1=rVac(),r2=rCNC(),center=false);
}

module innerAdapter(){
	cylVAC();
	translate([0,0,(hVac()+50)-0.2]){
		cylCNC();
	}
	translate([0,0,hVac()-0.1]){
		cylMid();
	}
}

module outerAdapter(){
	scale([1.1,1.1,.99]){
		innerAdapter();
	}
}

module cubeNub(){
	cube([20,wNub(),hNub()]);
}

module theAdapter(){
	difference(){
		outerAdapter();
		translate([0,0,-0.1]){
			innerAdapter();
		}
		translate([rCNC()-10,-wNub()/2,(hVac()+hCNC()+50-hNub())]){
			cubeNub();
		}
	}
}

theAdapter();

