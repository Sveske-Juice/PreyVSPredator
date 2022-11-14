public class Predator extends Animal
{
    public Predator(String name)
    {
        super(name);
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();
        //AddComponent(new PreyMover(5f));
    }
}
