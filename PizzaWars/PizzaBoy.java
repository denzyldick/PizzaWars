import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)
import java.util.List;

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
   
    World world;
    private final int SPEED = 2;
    private final int FALLING_SPEED = 5;
    private final int JUMP_LIMIT = 60;
    private int frame = 0;
    
    private GreenfootImage[] pizzaboy = new GreenfootImage[8];


    private int FRAME_LIMIT = 8;
    private boolean isFlipped = true;
    private boolean falling   = true;
    private String facing  = "right";
    private String[] keys  = new String[4];
    private int levens = 5;
    private int animationCount = 0;
    private int jumpTimer = 0;
    
    public PizzaBoy(boolean type,String left,String right,String jump,String shoot)
    {
        keys[0] = left;
        keys[1] = right;
        keys[2] = jump;
        keys[3] = shoot;
        world = (PlayArea)getWorld();
       
        if(type)
        {
            pizzaboy[0]  = new GreenfootImage("red/playerIdle0.png");
            pizzaboy[1]  = new GreenfootImage("red/playerWalking0.png");
            pizzaboy[2]  = new GreenfootImage("red/playerWalking1.png");
            pizzaboy[3]  = new GreenfootImage("red/playerWalking2.png");
            pizzaboy[4]  = new GreenfootImage("red/playerWalking3.png");
            pizzaboy[5]  = new GreenfootImage("red/playerWalking4.png");
            pizzaboy[6]  = new GreenfootImage("red/playerWalking5.png");
            pizzaboy[7]  = new GreenfootImage("red/playerJumping.png");
        }else if(!type)
        {
            pizzaboy[0]  = new GreenfootImage("green/playerIdle0.png");
            pizzaboy[1]  = new GreenfootImage("green/playerWalking0.png");
            pizzaboy[2]  = new GreenfootImage("green/playerWalking1.png");
            pizzaboy[3]  = new GreenfootImage("green/playerWalking2.png");
            pizzaboy[4]  = new GreenfootImage("green/playerWalking3.png");
            pizzaboy[5]  = new GreenfootImage("green/playerWalking4.png");
            pizzaboy[6]  = new GreenfootImage("green/playerWalking5.png");
            pizzaboy[7]  = new GreenfootImage("green/playerJumping.png");
        }
      
       
        setImage(pizzaboy[0]);
       
    }
   
    public void act() 
    {
        this.collisionDetection();  
        this.keyControl();
        if(this.falling) this.fall();
        animationCount++;
          
    }    
    private void moveRight()
    {
        if(!falling)
        {
       this.setLocation((this.getX() + this.SPEED),this.getY());
        }
    if(animationCount % 4 == 0)
    {
    this.animateRight();
    facing = "right";
    }}
    private void animateRight()
    {
       if(frame < this.FRAME_LIMIT)
       {
     
        setImage(pizzaboy[frame]);
        frame++;
    }else
    {
        frame = 0;
    }
    }
 
    private void moveLeft()
    {
        if(!falling)
        {
        this.setLocation((this.getX() - this.SPEED),this.getY());
      
        
    }
    if(animationCount  % 4 == 0)
    {
        facing =  "left";
        this.animateLeft();
    }}
    
     private void animateLeft()
    {
        if(frame < this.FRAME_LIMIT)
        {
            GreenfootImage flipped = pizzaboy[frame];
           flipped.mirrorHorizontally();/// flip image
       
            
            frame++;
            
        }else
        {
            frame = 0;
        }

       
    }
    private void jump()
    {this.setLocation(this.getX(),(this.getY() - 1));
                this.animateJump();
        if(!this.falling)
        {
           if(true)
           {
                this.setLocation(this.getX(),(this.getY() - 1));
                this.animateJump();
         
            }else
            {
            this.falling  = true;
        }
             jumpTimer++;
        }
              
    }
    
    private void animateJump()
    {
        setImage(pizzaboy[6]);
    }
    private void fall()
    {
        this.setLocation(this.getX(),(this.getY() + this.FALLING_SPEED));
    }
    private void collisionDetection()
    {
    
        Platform  platform  =  (Platform)getOneIntersectingObject(Platform.class);
    
            try{
                    GreenfootImage  platformimage    =  platform.getImage();
                    GreenfootImage  pizzaboyimage    = platform.getImage();
                    setLocation(this.getX(),(platform.getY()-platformimage.getHeight()));
                    this.falling = false;
                    jumpTimer =0;
                    if((this.getX() + pizzaboyimage.getWidth()) < platform.getX())
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
        // Move right
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
            {
                setImage(pizzaboy[6]);
            }else{
                
                setImage(pizzaboy[0]);   
            }
        }
       
    }
  
}
