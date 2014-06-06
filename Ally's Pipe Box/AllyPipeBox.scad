function woodThickness()=3.175;
function boxWidth()=200;
function boxDepth()=140;
function boxHeight()=140;

function topWidth()=boxWidth();
function topDepth()=boxDepth();
function topHeight()=woodThickness();

function frontWidth()=boxWidth();
function frontDepth()=woodThickness();
function frontHeight()=boxHeight();

function backWidth()=boxWidth();
function backDepth()=woodThickness();
function backHeight()=boxHeight();

function bottomWidth()=boxWidth();
function bottomDepth()=boxDepth();
function bottomHeight()=woodThickness();

function leftWidth()=woodThickness();
function leftDepth()=boxDepth();
function leftHeight()=boxHeight();

function rightWidth()=woodThickness();
function rightDepth()=boxDepth();
function rightHeight()=boxHeight();

function tabWidth()=15;
function tabDepth()=woodThickness();
function tabHeight()=10;

function pinWidth()=(woodThickness()*2);
function pinDepth()=woodThickness();
function pinHeight()=15;

module fillet(r=woodThickness(),h=woodThickness()+0.01){
    translate([r/2,r/2,r/2])
        difference() {
            cube([r+0.01,r+0.01,h],center=true);
            translate([r/2,r/2,0])
                cylinder(r=r,h=h+1,center=true);

        }
}

module tab(){
	difference(){
		cube([tabWidth(),tabDepth(),tabHeight()]);
		translate([0,0,tabHeight()]){
			rotate([-90,0,0]){
				fillet();
			}
		}
		translate([tabWidth(),tabDepth(),tabHeight()]){
			rotate([-90,0,180]){
				fillet();		
			}
		}
	}
}

module pin(){
	difference(){
		cube([pinWidth(),pinDepth(),pinHeight()]);
		translate([0,pinDepth(),0]){
			rotate([90,0,0]){
				scale([1/2,1/2,1]){
					fillet();
				}
			}
		}
		translate([0,0,pinHeight()-5]){
			rotate([-90,0,0]){
				scale([1/2,1/2,1]){
					fillet();
				}
			}
		}
		translate([-0.01,-0.01,pinHeight()-5]){
			rotate([0,0,0]){
				cube([((pinWidth()/2)+0.01),(pinDepth()+0.02),(5+0.01)]);
			}
		}
	}
}

module tabAndPin(){
	difference(){
		tab();
		translate([((pinDepth()+tabWidth())/2),-10,pinWidth()]){
			rotate([-90,90,0]){
				pin();
			}
		}
	}
}

module frontSide(){
	cube([frontWidth(),frontDepth(),frontHeight()]);
}

tabAndPin();
