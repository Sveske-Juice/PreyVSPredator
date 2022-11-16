public class CollissionSystem
{
    /* Members. */
    private ArrayList<Collider> m_Colliders = new ArrayList<Collider>();

    public void RegisterCollider(Collider collider)
    {
        if (collider == null)
            return;

        m_Colliders.add(collider);
    }

    public void CheckCollisions()
    {
        
    }

}