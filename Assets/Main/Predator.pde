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

public class PredatorMover extends AnimalMover
{

    @Override
    public void Start()
    {
        m_GameObject.GetComponent(Collider.class).SetColor(color(180, 0, 0, 60));
    }
}
