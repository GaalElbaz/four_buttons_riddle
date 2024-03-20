`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: game
//////////////////////////////////////////////////////////////////////////////////
typedef enum logic {OFF = 1'b0, ON = 1'b1} button_state;
class buttons;
    // declaring buttons state
    rand button_state buttonUL, buttonUR, buttonDL, buttonDR;
    // declare iteartion
    
    // display function
    function void displaySTATE();
        $display("buttonUL : %s, buttonUR : %s, buttonDL : %s, buttonDR : %s", buttonUL.name(), buttonUR.name(), buttonDL.name(), buttonDR.name());
        $display("-------------------------------------------------------------");
    endfunction 
    
    constraint buttonST {
        buttonUL inside {[0:1]};
        buttonUR inside {[0:1]};
        buttonDL inside {[0:1]};
        buttonDR inside {[0:1]};
    }
    
    constraint uniqe{
        buttonUL != buttonUR || buttonUL != buttonDL || buttonUL != buttonDR; 
        }
        
//    constraint even_adjacent_button {
//        buttonUL == buttonUR;
//        buttonUL != buttonDL;
//        buttonUL != buttonDR;
//    }

      constraint odd_buttons {
        buttonUL == buttonUR;
        buttonUL == buttonDL;
        buttonUL != buttonDR;
      }
endclass

class rotation;
    rand int angle;
    
    // display function
    function void display();
        $display("The table turned at an angle of %d", angle);
    endfunction
    // Constraint to restrict angle to 90, 180, 270, or 360
    constraint valid_angle {
        angle inside {90, 180, 270, 360};
    }
endclass

class game;
    // declaring buttons 
    buttons bu;
    // declaring rotation of table
    rotation an;
    // declaring itreation number
    int i;
    // declaring output
    logic light;
    
    // custome constructor
    function new();
        bu = new();
        an = new();
        light = 1'b0;
        i = 1;
    endfunction
    
    task run();
        $display("GAME START IN STATE");
        bu.randomize();
        bu.displaySTATE();
        while(!light) begin
            $display("iteration number %0d:",i);
            light = solve_problem(i);
            i++;
            if(!light) begin
                $display("Bad button combination, the table rotates.");
                // call randomize of angle
                an.randomize();
                rotate_button(an.angle);
            end
            $display("Current State is:");
            bu.displaySTATE();
        end
        $display("Good button combination, you won!");
        bu.displaySTATE();
    endtask
    
    function logic solve_problem(int iteration);
        case(iteration)
        1: begin
            bu.buttonUR = change_state(bu.buttonUR);
            bu.buttonDL = change_state(bu.buttonDL);
            return check_buttons;
        end
        2: begin
            bu.buttonUL = change_state(bu.buttonUL);
            bu.buttonUR = change_state(bu.buttonUR);
            return check_buttons;
        end
        3: begin
            bu.buttonUL = change_state(bu.buttonUL);
            bu.buttonDR = change_state(bu.buttonDR);
            return check_buttons;
        end
        4: begin
            bu.buttonDR = change_state(bu.buttonDR);
            return check_buttons;
        end
        5: begin
            bu.buttonUL = change_state(bu.buttonUL);
            bu.buttonDR = change_state(bu.buttonDR);
            return check_buttons;
        end
        6: begin
            bu.buttonUL = change_state(bu.buttonUL);
            bu.buttonUR = change_state(bu.buttonUR);
            return check_buttons;
        end 
        7: begin
            bu.buttonUL = change_state(bu.buttonUL);
            bu.buttonDR = change_state(bu.buttonDR);
            return check_buttons;
        end
        endcase
    endfunction
    
    function logic check_buttons();
        if(bu.buttonUL == bu.buttonUR && bu.buttonUL == bu. buttonDL && bu.buttonUL == bu.buttonDR)
            return 1'b1;
        else
            return 1'b0;
    endfunction
    
    function button_state change_state(button_state btn);
        if(btn == ON) 
            return OFF;
        else
            return ON;
    endfunction
    
    function void rotate_button(int angle);
    button_state temp;
        case(angle)
        90: begin
            temp = bu.buttonUL;
            bu.buttonUL = bu.buttonDL;
            bu.buttonDL = bu.buttonDR;
            bu.buttonDR = bu.buttonUR;
            bu.buttonUR = temp; 
        end
        180: begin
            temp = bu.buttonUL;
            bu.buttonUL = bu.buttonDR;
            bu.buttonDR = temp;              
            temp = bu.buttonDL;
            bu.buttonDL = bu.buttonUR;
            bu.buttonUR = temp; 
        end
        270: begin
            temp = bu.buttonUL;
            bu.buttonUL = bu.buttonUR;
            bu.buttonUR = bu.buttonDR;
            bu.buttonDR = bu.buttonDL;
            bu.buttonDL = temp; 
        end
        endcase
    endfunction
endclass


module tb;
    game main;
    
    initial begin
        main = new();
        main.run;
        #100
        $finish();
    end
endmodule