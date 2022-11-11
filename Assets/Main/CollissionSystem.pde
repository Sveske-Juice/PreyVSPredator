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
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            Collider collider = m_Colliders.get(i);
            if (collider instanceof CircleCollider)
            {
                //println("Collider: " + collider.GetName() + " is a circle collider");
                for (int j = i + 1; j < m_Colliders.size(); j++)
                {
                    println("Checking for collision between " + collider.GetName() + " on " + collider.GetGameObject().GetName() + " and " +  m_Colliders.get(j).GetName() + " on " + m_Colliders.get(j).GetGameObject().GetName());
                    collider.CollideAgainstCircle((CircleCollider) m_Colliders.get(j));
                }
            }
        }

        println("-- New Frame --");
        
    }
}