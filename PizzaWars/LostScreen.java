import greenfoot.*;

public class LostScreen extends World
{
    private static final int WIDTH = 600;
    private static final int HEIGHT = 400;
    private static final int RESTART_DELAY = 30;

    private int timer;

    public LostScreen(String loser)
    {
        super(WIDTH, HEIGHT, 1);
        if (loser.equals("red"))
        {
            setBackground("greenwins.png");
        }
        else
        {
            setBackground("redwins.png");
        }
        showText("Click or press SPACE to return to menu", WIDTH / 2, HEIGHT - 20);
    }

    @Override
    public void act()
    {
        timer++;
        if (timer > RESTART_DELAY && (Greenfoot.mouseClicked(null) || Greenfoot.isKeyDown("space")))
        {
            Greenfoot.setWorld(new Menu());
        }
    }
}
