
  module pong (
input                   clk            ,
input                   rst          ,
input                   fifo_pop       , 
input      [11:0]       column         ,
input      [10:0]       row            ,
output reg [8+8+8-1:0]  fifo_data      ,
input                   btn1      ,
input                   btn2      ,
input [3:0]             switches    
);




  reg [20:0] count;
  reg [21:0] count2;
  reg [21:0] count3;
  reg [2:0]  loop;
  
  reg [7:0] r;
  reg [7:0] g;
  reg [7:0] b;

  //wall check
  reg top;
  reg down;
  
  
  reg bounce1;
  reg bounce2;
  reg bounce3;
  reg bounce4;
  reg bounce5;
  
  reg increment;
  
  
  
  reg right;
  reg left;
  
  reg Player_1_Top;
  reg Player_1_Bottom;
  
  reg Player_2_Top;
  reg Player_2_Bottom;

  
  //size and coordinates for the ball
  reg [10:0] Ax;
  reg [11:0] Ay;
  reg [10:0] Bx;
  reg [11:0] By;
  reg [10:0] Cx;
  reg [11:0] Cy;
  reg [10:0] Dx;
  reg [11:0] Dy;
  
  reg [10:0] Player_1_Ax;
  reg [6:0]  Player_1_Ay;
  reg [10:0] Player_1_Bx;
  reg [6:0]  Player_1_By;
  reg [10:0] Player_1_Cx;
  reg [6:0]  Player_1_Cy;
  reg [10:0] Player_1_Dx;
  reg [6:0]  Player_1_Dy;
  
  reg [10:0]  Player_2_Ax;
  reg [11:0]  Player_2_Ay;
  reg [10:0]  Player_2_Bx;
  reg [11:0]  Player_2_By;
  reg [10:0]  Player_2_Cx;
  reg [11:0]  Player_2_Cy;
  reg [10:0]  Player_2_Dx;
  reg [11:0]  Player_2_Dy;
  
  reg [1:0]  count_frames ;  
  reg [1:0]  count_seconds; 
  
  reg [3:0] verticalSpeed;
  reg [3:0] horizontalSpeed;
  
  reg q;
  wire rst_n;
  wire eof;
  assign rst_n=~rst;


      
always @(posedge clk or negedge rst_n)
 if(~rst_n)
     q<=1'b0;
 else 
     q<=row[10];
        
  assign eof = q & (~row[10]); //end of frame
    
    

always @(posedge clk or negedge rst_n)
  if(~rst_n)
  count_frames<=0;
  else  if(eof)
      count_frames<=count_frames + 1; 
      
always @(posedge clk or negedge rst_n)
  if(~rst_n)
  count_seconds<=0;
  else
    if(count_frames==0 )
      count_seconds <=count_seconds+1; 
   
         
always @(posedge clk or negedge rst_n)
    if (~rst_n)   
       begin
           count <= 18'b0;
       
           Ax  <=  10;
           Ay  <=  10;
           Bx  <=  10;
           By  <=  50;
           Cx  <=  50;
           Cy  <=  10;
           Dx  <=  50;
           Dy  <=  50;
          
       end
         
    else 
    begin
    count <= count+1;
      //if(eof) 
        if(count[20] && ~switches[2])
           begin
         
                 if (down) begin
                    Ax  <=  Ax-verticalSpeed;
                    Bx  <=  Bx-verticalSpeed;
                    Cx  <=  Cx-verticalSpeed;
                    Dx  <=  Dx-verticalSpeed;             
                 end
                 else if(top) begin
                    Ax  <=  Ax+verticalSpeed;
                    Bx  <=  Bx+verticalSpeed;
                    Cx  <=  Cx+verticalSpeed;
                    Dx  <=  Dx+verticalSpeed;                 
                 end       
                                                                                                                        
                   if(left)
                 begin
                 Ay  <=  Ay+horizontalSpeed;
                 By  <=  By+horizontalSpeed;
                 Cy  <=  Cy+horizontalSpeed;
                 Dy  <=  Dy+horizontalSpeed;                             
                end
                 else if(right)
                  begin
                 Ay  <=  Ay-horizontalSpeed;
                 By  <=  By-horizontalSpeed;
                 Cy  <=  Cy-horizontalSpeed;
                 Dy  <=  Dy-horizontalSpeed;                
                  end 
                  
                 
                  
                  count<=20'b0;
             end  
             
             
             end      
             
             
always @(posedge clk or negedge rst_n)
      if(~rst_n)
           loop<=3'b0;
      else
          begin
             if(Cx>=700  ||  Bx<=20  ||  By>=1270  ||  Ay<=10)     //change color if wall hit
              loop<=loop+1;
              
          case (loop)
             3'b000 :
             begin            
              r <= 8'd255; 
              g <= 8'd0;
              b <= 8'd0;
             end
             3'b001 :     
             begin   
              r <= 8'd0; 
              g <= 8'd255;
              b <= 8'd0;
             end               
             3'b010: 
             begin                
                r <= 8'd0; 
                g <= 8'd0;
                b <= 8'd255;
             end      
             3'b011: 
             begin   
                r <= 8'd255; 
                g <= 8'd255;
                b <= 8'd0;
             end  
             3'b100:
             begin   
                r <= 8'd255; 
                g <= 8'd0;
                b <= 8'd255;
             end      
             3'b101:
             begin   
                r <= 8'd0; 
                g <= 8'd255;
                b <= 8'd255;
             end      
             3'b110:
             begin   
                r <= 8'd255; 
                g <= 8'd255;
                b <= 8'd0;
             end    
             3'b111:
              begin  
                r <= 8'd255; 
                g <= 8'd255;
                b <= 8'd255;
             end   
             default:          
             begin   
                r <= 8'd255; 
                g <= 8'd255;
                b <= 8'd0;
             end                                       
             endcase      
                    
         end   

           
always @(posedge clk or negedge rst_n)
      if(~rst_n)
      begin
      
      verticalSpeed   <=1;
      horizontalSpeed <=1;
          
          
        top   <= 1'b1;
        down  <= 1'b0;
        right <= 1'b0;
        left  <= 1'b1;
                    
       end
       else
          if(eof) 
        begin
            //check if top or bottom was hit
         if(Cx>=700)
           begin
             down <= 1'b1;
             top  <= 1'b0;                              
           end
           else if(Bx<=20)
           begin
             down <=  1'b0;
             top  <=  1'b1;             
            end 
            
           
           
         // check if it intersects with player2          
           // bounce1
           if(By >= 1240)
              begin                      
                 if( Ax <= Player_2_Ax && Cx >= Player_2_Ax) // if ball is higher than the racket
                  begin
                  
                   verticalSpeed<=6;
                  horizontalSpeed<=horizontalSpeed*1;   
                  
                            
                     top     <=  1'b0;                     
                     down    <=  1'b1;                                                     
                     right   <=  1'b1;
                     left    <=  1'b0;                    
                   //  bounce1<=~bounce1;
                  end
                //bounce2
                 else if (Ax >= Player_2_Ax && Cx <= Player_2_Ax + (Player_2_Cx - Player_2_Ax)/2 ) // if ball is in between the top and middle 
                 begin
                 
                  verticalSpeed<=verticalSpeed<=3;
                  horizontalSpeed<=horizontalSpeed*1;   
                  
                             
                   top     <=  1'b0;
                   down    <=  1'b1;                
                   right   <=  1'b1;
                   left    <=  1'b0;
                 //  bounce2<=~bounce2;
                  end                 
                   //bounce4
                     else if (Cx <= Player_2_Cx && Ax >= Player_2_Ax + (Player_2_Cx - Player_2_Ax)/2   )  // if ball is lower  than the racket
                 begin
                 
                  verticalSpeed<=verticalSpeed<=3;
                  horizontalSpeed<=horizontalSpeed*1;               
                   top     <=  1'b1;
                   down    <=  1'b0;                    
                   right   <=  1'b1;
                   left    <=  1'b0;
                //   bounce4<=~bounce4;
                  end
                 //bounce 5
                   else if (Ax <= Player_2_Cx && Cx >= Player_2_Cx ) // if ball is in between the low and middle 
                 begin
                 
                  verticalSpeed<=verticalSpeed<=6;
                  horizontalSpeed<=horizontalSpeed*1;      
                                
                   top     <=  1'b1;
                   down    <=  1'b0;                   
                   right   <=  1'b1;
                   left    <=  1'b0;
                   //bounce5<=~bounce5;
                  end
                
                 else if(By>=1270)
                 begin
                               
                   top     <=  1'b0;
                   down    <=  1'b1;                                                     
                   right   <=  1'b1;
                   left    <=  1'b0;  
                   
                end
                
                   if((down && top) || (~down && ~top))
                  begin
                   down<=~down;
                  end
         end
         
         
           //check if intersects with player1
           
         if(Ay<=40)
            begin                     
             if( Ax <= Player_1_Ax && Cx >= Player_1_Ax) // if ball is higher than the racket
                  begin
                  
                    verticalSpeed<=6;
                  horizontalSpeed<=horizontalSpeed*1;   
                                    
                     top     <=  1'b0;
                     down    <=  1'b1; 
                                                                        
                     right   <=  1'b0;
                     left    <=  1'b1;                    
                  //   bounce1<=~bounce1;
                  end
                //bounce2
                 else if (Ax >= Player_1_Ax && Cx <= Player_1_Ax + (Player_1_Cx - Player_1_Ax)/2 ) // if ball is in between the top and middle 
                 begin
                 
                  verticalSpeed<=3;
                  horizontalSpeed<=horizontalSpeed*1;    
                  
          
                                     
                   top     <=  1'b0;
                   down    <=  1'b1;     
                              
                   right   <=  1'b0;
                   left    <=  1'b1;  
              
                  end                 
                   //bounce4
                  else if (Cx <= Player_1_Cx && Ax >= Player_1_Ax + (Player_1_Cx - Player_1_Ax)/2   )  // if ball is lower  than the racket
                 begin                
                 verticalSpeed<=3;
                 horizontalSpeed<=horizontalSpeed*1;    
                 
                          
                   top     <=  1'b1;               
                   down    <=  1'b0;    
                                  
                   right   <=  1'b0;                  
                   left    <=  1'b1;  
            
                  end
                   else if (Ax <= Player_1_Cx && Cx >= Player_1_Cx ) // if ball is in between the low and middle 
                 begin
                 
                  verticalSpeed<=6;
                  horizontalSpeed<=horizontalSpeed*1;   
                                         
                   top     <=  1'b1;
                   down    <=  1'b0; 
                                     
                   right   <=  1'b0;
                   left    <=  1'b1;  
                 
                  end                                                    
                 else if(Ay<=10)               
                 begin
                   top     <=  1'b0;
                   down    <=  1'b1; 
                   right   <=  1'b0;
                   left    <=  1'b1;                
                               
                end
                   if((down && top) || (~down && ~top))
                  begin
                   down<=~down;
                  end
                       
                   
         end          
       end        
       
               
always @(posedge clk or negedge rst_n)
    if (~rst_n)   
       begin
         Player_1_Ax  <=  290;
         Player_1_Ay  <=  10;
         Player_1_Bx  <=  290;
         Player_1_By  <=  40;
         Player_1_Cx  <=  430;
         Player_1_Cy  <=  10;
         Player_1_Dx  <=  430;
         Player_1_Dy  <=  40;
         
         count2<=22'b0;
       end
       else
       begin
       count2<=count2+1;
        if( count2[21]) 
           begin
             if(btn2 && switches[1] && Player_1_Ax >=10 && ~switches[2])
                begin
                 Player_1_Ax  <=  Player_1_Ax-3;
                 Player_1_Bx  <=  Player_1_Bx-3;
                 Player_1_Cx  <=  Player_1_Cx-3;
                 Player_1_Dx  <=  Player_1_Dx-3;             
                end
                else if(btn2 && ~switches[1] && Player_1_Cx <=710 && ~switches[2])
                begin
                 Player_1_Ax  <=  Player_1_Ax+3;
                 Player_1_Bx  <=  Player_1_Bx+3;
                 Player_1_Cx  <=  Player_1_Cx+3;
                 Player_1_Dx  <=  Player_1_Dx+3;                     
                end  
                
               else if(Player_1_Top && ~switches[2])
                begin
                 Player_1_Ax  <=  Player_1_Ax+1;
                 Player_1_Bx  <=  Player_1_Bx+1;
                 Player_1_Cx  <=  Player_1_Cx+1;
                 Player_1_Dx  <=  Player_1_Dx+1;              
                end        
                else if(Player_1_Bottom && ~switches[2])
                begin
                Player_1_Ax  <=   Player_1_Ax-1;
                 Player_1_Bx  <=  Player_1_Bx-1;
                 Player_1_Cx  <=  Player_1_Cx-1;
                 Player_1_Dx  <=  Player_1_Dx-1; 
                end 
                   
                   
                    count2<=22'b0;   
           end 
             
        end   
                     
always @(posedge clk or negedge rst_n)
    if (~rst_n)   
       begin
         Player_2_Ax  <=  290;
         Player_2_Ay  <=  1240;
         Player_2_Bx  <=  290;
         Player_2_By  <=  1270;
         Player_2_Cx  <=  430;
         Player_2_Cy  <=  1240;
         Player_2_Dx  <=  430;
         Player_2_Dy  <=  1270;
         
         count3<=22'b0;
       end
       else
       begin
       count3<=count3+1;
       
        if(count3[21] ) 
           begin
           
             if(btn1 && switches[0] && Player_2_Ax >=10 && ~switches[2])
                begin
                 Player_2_Ax  <=  Player_2_Ax-3;
                 Player_2_Bx  <=  Player_2_Bx-3;
                 Player_2_Cx  <=  Player_2_Cx-3;
                 Player_2_Dx  <=  Player_2_Dx-3;             
                end   
              else if(btn1 && ~switches[0] && Player_2_Cx <=710 && ~switches[2])
                begin
                 Player_2_Ax  <=  Player_2_Ax+3;
                 Player_2_Bx  <=  Player_2_Bx+3;
                 Player_2_Cx  <=  Player_2_Cx+3;
                 Player_2_Dx  <=  Player_2_Dx+3;                     
                end    
                
              else  if (Player_2_Top && ~switches[2])  
                begin
                 Player_2_Ax  <=  Player_2_Ax+1;
                 Player_2_Bx  <=  Player_2_Bx+1;
                 Player_2_Cx  <=  Player_2_Cx+1;
                 Player_2_Dx  <=  Player_2_Dx+1;                              
                end      
                else if (Player_2_Bottom && ~switches[2])   
                begin
                 Player_2_Ax  <=  Player_2_Ax-1;
                 Player_2_Bx  <=  Player_2_Bx-1;
                 Player_2_Cx  <=  Player_2_Cx-1;
                 Player_2_Dx  <=  Player_2_Dx-1;                 
                end
                 count3<=22'b0; 
           end
           
         end
         
   always @(posedge clk or negedge rst_n)
if(~rst_n)
 begin
   Player_1_Top    <= 1'b1;
   Player_1_Bottom <= 1'b0;
 end
 else
    if(eof) 
      begin
   if(Player_1_Cx >= 715)
     begin
       Player_1_Bottom <= 1'b1;
       Player_1_Top  <= 1'b0;           
     end
     else if(Player_1_Ax <= 5)
     begin
       Player_1_Bottom <=  1'b0;
       Player_1_Top  <=  1'b1;
      end 
   end 
   
   
    always @(posedge clk or negedge rst_n)
if(~rst_n)
 begin
   Player_2_Top    <= 1'b0;
   Player_2_Bottom <= 1'b1;
 end
 else
    if(eof) 
      begin
   if(Player_2_Cx >= 715)
     begin
       Player_2_Bottom <= 1'b1;
       Player_2_Top  <= 1'b0;           
     end
     else if(Player_2_Ax <= 5)
     begin
       Player_2_Bottom <=  1'b0;
       Player_2_Top  <=  1'b1;
      end 
   end
  //   
         
always @(posedge clk or negedge rst_n)
      if(~rst_n)
        fifo_data<= {8'd0,8'd0,8'd0};
      else 
      begin
          if(row >= Ax && row <= Dx && column >= Ay && column <= By)
             fifo_data <= {r, g, b}; 
          else
             fifo_data <= {8'd0, 8'd0, 8'd0};  
             
          if( row>=Player_1_Ax && row <= Player_1_Dx && column >= Player_1_Ay && column <= Player_1_By)
              fifo_data<= {8'd255,8'd255,8'd255};
          if( row>=Player_2_Ax && row <= Player_2_Dx && column >= Player_2_Ay && column <= Player_2_By)
              fifo_data<= {8'd255,8'd255,8'd255};
              
      end
