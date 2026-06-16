import greenfoot.*;

public class Menu extends World
{
    private static final int WIDTH = 600;
    private static final int HEIGHT = 400;

    public Menu()
    {
        super(WIDTH, HEIGHT, 1);
        addObject(new Logo(), 900, 100);
        addObject(new Start(), 0, 200);
        addObject(new Instruction(), 900, 300);
    }
}
