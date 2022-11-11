public abstract class Collider extends Component
{
    public Collider(String name)
    {
        m_Name = name;
    }
    
    @Override
    public void Start()
    {
        m_GameObject.GetBelongingToScene().GetCollissionSystem().RegisterCollider(this);
    }

    
    public abstract void CollideAgainstCircle(CircleCollider collider);
}