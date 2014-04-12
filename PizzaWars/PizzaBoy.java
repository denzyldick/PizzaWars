import greenfoot.*;  // (World, Actor, GreenfootImage, Greenfoot and MouseInfo)

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
    private final int JUMPLIMIT = 10;
    private int frame = 0;
    private GreenfootImage[] pizzaboy = new GreenfootImage[8];
    private int FRAME_LIMIT = 8;
    private boolean isFlipped = true;
    private boolean falling   = true;
    private String facing  = "right";
    private String[] keys  = new String[4];
    public PizzaBoy(boolean type,String left,String right,String jump,String shoot)
    {
        keys[0] = left;
        keys[1]  =  right;
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
            //second character
        }
        setImage(pizzaboy[0]);
     
    }
    public void act() 
    {
        this.collisionDetection();  
        this.keyControl();
        if(this.falling) this.fall();
          
    }    
    private void moveRight()
    {if(!falling)
        {
       this.setLocation((this.getX() + this.SPEED),this.getY());
    }this.animateRight();
       facing = "right";
    }
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
    facing =  "left";
      this.animateLeft();
    }
    
       private void animateLeft()
    {
        if(frame < this.FRAME_LIMIT)
        {
            GreenfootImage flipped = pizzaboy[frame];
            flipped.mirrorHorizontally();/// flip image
            setImage(flipped);
            
            frame++;
            
        }else
        {
            frame = 0;
        }

       
    }
    private void jump()
    {
        if(!this.falling)
        {
            for(int i = 0; i < JUMPLIMIT; i++)
            {
                this.setLocation(this.getX(),(this.getY() - i));
                this.animateJump();
            }
            this.falling  = true;
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
      
        this.getWorld().addObject( new PizzaSlice(this,facing),this.getX(),this.getY());
        Greenfoot.delay(5);
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
