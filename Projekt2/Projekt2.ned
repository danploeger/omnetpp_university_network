//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package projekt2;


simple sender {
  parameters:
      volatile double delayTime @unit(s); 
  gates:
  //  input in;
    output out;
    

}

simple receiver {
 
     gates:
     input in;

}



network Projekt2 {

submodules:
    
    R:receiver;
    S:sender{delayTime=exponential(3s);};
connections:
    
    S.out -->{delay=100ms;}--> R.in;
    //S.in <--{delay=100ms;}<-- R.out;



}


