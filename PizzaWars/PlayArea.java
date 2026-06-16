import greenfoot.*;

public class PlayArea extends World
{
    private static final int GROUND_Y = 500;
    private static final int WIDTH = 600;
    private static final int HEIGHT = 400;
    private static final int MUSIC_VOLUME = 20;
    private static final int GROUND_SEGMENTS = 7;
    private static final int PLATFORM_SPACING = 97;

    private PizzaBoy redBoy;
    private PizzaBoy greenBoy;
    private final GreenfootSound musicLoop;

    public PlayArea()
    {
        super(WIDTH, HEIGHT, 1);
        musicLoop = new GreenfootSound("music.mp3");
        redBoy = new PizzaBoy("red", "a", "d", "w", "s", 8, 12);
        greenBoy = new PizzaBoy("green", "left", "right", "up", "down", 510, 12);

        generatePlatforms();
        addObject(redBoy, 100, 40);
        addObject(greenBoy, 460, 40);
        musicLoop.setVolume(MUSIC_VOLUME);
    }

    private void generatePlatforms()
    {
        addObject(new Platform(), 1, 99);
        addObject(new Platform(), 100, 100);
        addObject(new Platform(), 211, 124);
        addObject(new Platform(), 373, 127);
        addObject(new Platform(), 559, 74);
        addObject(new Platform(true, 30), 515, 224);
        addObject(new Platform(), 312, 276);
        addObject(new Platform(true, 10), 103, 337);

        for (int i = 0; i < GROUND_SEGMENTS; i++)
        {
            addObject(new Platform(), i * PLATFORM_SPACING, GROUND_Y);
        }
    }

    @Override
    public void act()
    {
        musicLoop.playLoop();
        if (redBoy.getLives() == 0)
        {
            Greenfoot.setWorld(new LostScreen("red"));
        }
        else if (greenBoy.getLives() == 0)
        {
            Greenfoot.setWorld(new LostScreen("green"));
        }
    }
}
