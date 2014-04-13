import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)
import java.util.List;
import java.util.ArrayList;

/**
 * Write a description of class PizzaBoy here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class PizzaBoy extends Actor
{
    /**
     * Act - do whatever the PizzaBoy wants to do. This method is called whenever
     * the 'Act' or 'Run' button gets pressed in the environment.
     */
    private World world;
    private final int SPEED = 2;
    private final int FALLING_SPEED = 5;
    private final int JUMP_LIMIT = 100;
    private int frame = 0;    
    private GreenfootImage[] rightFacing = new GreenfootImage[8];
    private GreenfootImage[] leftFacing = new GreenfootImage[8];
    private int FRAME_LIMIT = 8;
    private boolean falling   = true;
    private boolean jumping   = false;
    private String facing  = "right";
    private String[] keys  = new String[4];
    private int animationCount = 0;
    private int jumpTimer = 0;
    private ArrayList<Heart> lives = new ArrayList<Heart>();
    private int startX, startY; 
    
    public PizzaBoy(String color,String left,String right,String jump,String shoot, int startX, int startY)
    {
        keys[0] = left;
        keys[1] = right;
        keys[2] = jump;
        keys[3] = shoot;
        this.startX =  startX;
        this.startY =  startY;
        world = (PlayArea)getWorld();
        selectColor(color);  
        lives.add(new Heart());
        lives.add(new Heart());
        lives.add(new Heart());
    
      
    }
    private void generateHeart()
    {
     for(Heart hearts : lives)
        {
       getWorld().addObject(hearts,startX += 22,startY);
  
      }
    }
    public int getLives()
    {
        return lives.size();
    }
   private void selectColor(String color)
   {
       rightFacing[0]  = new GreenfootImage(color +"/playerIdle0R.png");
       rightFacing[1]  = new GreenfootImage(color +"/playerWalking0R.png");
       rightFacing[2]  = new GreenfootImage(color +"/playerWalking1R.png");
       rightFacing[3]  = new GreenfootImage(color +"/playerWalking2R.png");
       rightFacing[4]  = new GreenfootImage(color +"/playerWalking3R.png");
       rightFacing[5]  = new GreenfootImage(color +"/playerWalking4R.png");
       rightFacing[6]  = new GreenfootImage(color +"/playerWalking5R.png");
       rightFacing[7]  = new GreenfootImage(color +"/playerJumpingR.png");
          
       leftFacing[0] = new GreenfootImage(color +"/playerIdle0L.png");
       leftFacing[1] = new GreenfootImage(color +"/playerWalking0L.png");
       leftFacing[2] = new GreenfootImage(color +"/playerWalking1L.png");
       leftFacing[3] = new GreenfootImage(color +"/playerWalking2L.png");
       leftFacing[4] = new GreenfootImage(color +"/playerWalking3L.png");
       leftFacing[5] = new GreenfootImage(color +"/playerWalking4L.png");
       leftFacing[6] = new GreenfootImage(color +"/playerWalking0L.png");
       leftFacing[7] = new GreenfootImage(color +"/playerJumpingL.png");
    }
   public void removeLives()
   {
       
       Heart obj = lives.get(lives.size() -1);
       getWorld().removeObject(obj);
      lives.remove(lives.size() - 1);
       
   }
    public void act() 
    {
        this.collisionDetection();  
        this.keyControl();
        if(this.falling) this.fall();
        animationCount++;
        generateHeart();
          
    }    
    private void moveRight()
    {
      
       this.setLocation((this.getX() + this.SPEED),this.getY());
          if((getX()+rightFacing[0].getWidth()) > getWorld().getWidth()-3)
      {
          setLocation(0,getY());    
      }
        
    
    facing = "right";
    this.animate();
    }
   
    private void animate()
    {  if(animationCount % 6 == 0)
    {animationCount = 0;
        if(frame < this.FRAME_LIMIT)
        {
           if(frame != 0 && frame != 6)
           {
               if(facing == "right")    setImage(rightFacing[frame]);
               else if(facing == "left") setImage(leftFacing[frame]);
              
           }
            frame++;
        }else
        {
            frame = 0;
        }}
    }
    private void moveLeft()
    {
       
      this.setLocation((this.getX() - this.SPEED),this.getY());
      
      if(getX() == 0)
      {
          setLocation(getWorld().getWidth(),getY());    
      }
        
    
  
        facing =  "left";
        this.animate();
    }
    
    private void jump()
    {

       if(!falling)
       {
        
       while(jumpTimer < 20)
       {
         this.setLocation(this.getX(),(this.getY() -this.FALLING_SPEED));
         jumpTimer++;
        }   
        }
        
        if(jumpTimer > JUMP_LIMIT)
        {
         jumping = false;
         falling = true;
         jumpTimer = 0;
        }
    
    }
    
    private void animateJump()
    {
        setImage(rightFacing[6]);
    }
    private void fall()
    {
        if(!jumping){
            
        this.setLocation(this.getX(),(this.getY() + this.FALLING_SPEED));
    }
    }
    private void collisionDetection()
    {
    
        Platform  platform  =  (Platform)getOneIntersectingObject(Platform.class);
    
            try{
                    GreenfootImage  platformimage    =  platform.getImage();
                    GreenfootImage  rightFacingimage    = platform.getImage();
                if(this.getY()< platform.getY() && (this.getX()+rightFacingimage.getWidth()) > platform.getX())
                {
                    setLocation(this.getX(),(platform.getY()-platformimage.getHeight()));
                    this.falling = false;
                    jumpTimer =0;
                }
                    if((this.getX() + (rightFacingimage.getWidth()-20)) < platform.getX())
                    {
                        this.falling = true;
                    }
    }catch(Exception e){
        this.falling = true;
    }
    }
    private void shootPizzaSlice()
    {
       List<PizzaSlice> slices = this.getWorld().getObjects(PizzaSlice.class);
      
       if( slices.size() == 0 ||slices.get(0).getOwner() != this )
       {
        this.getWorld().addObject( new PizzaSlice(this,facing),this.getX(),this.getY());
    }
    }
    private void keyControl()
    {
       
        if(Greenfoot.isKeyDown(keys[1]))
        {
            this.moveRight();
        }else if(Greenfoot.isKeyDown(keys[0]))
        {
            this.moveLeft();
        }else if(Greenfoot.isKeyDown(keys[2]))
        {
            this.jump();
        }else if(Greenfoot.isKeyDown(keys[3]))
        {
            this.shootPizzaSlice();
        }else
        {
            if(this.falling)
            {if(facing == "right") {
                setImage(rightFacing[6]);
            }else
            {
                setImage(leftFacing[6]);
            }
            }else{
              if(facing == "right") {
                setImage(rightFacing[0]);
            }else
            {
                setImage(leftFacing[0]);
            }
            }
        }
       
    }
  
}
