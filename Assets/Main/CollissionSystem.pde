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
            if (CircleCollider.class.isAssignableFrom(collider.getClass()))
            {
                //println("Collider: " + collider.GetName() + " is a circle collider");
                for (int j = i + 1; j < m_Colliders.size(); j++)
                {
                    println("Checking for collision between " + collider.GetName() + " on " + collider.GetGameObject().GetName() + " and " +  m_Colliders.get(j).GetName() + " on " + m_Colliders.get(j).GetGameObject().GetName());
                    RunCollisionCheck(m_Colliders.get(i), m_Colliders.get(j));
                }
            }
            else if (BoxCollider.class.isAssignableFrom(collider.getClass()))
            {
                //println("Collider: " + collider.GetName() + " is a circle collider");
                for (int j = i + 1; j < m_Colliders.size(); j++)
                {
                    println("Checking for collision between " + collider.GetName() + " on " + collider.GetGameObject().GetName() + " and " +  m_Colliders.get(j).GetName() + " on " + m_Colliders.get(j).GetGameObject().GetName());
                    RunCollisionCheck(m_Colliders.get(i), m_Colliders.get(j));
                }
            }
        }

        println("-- New Frame --");
        
    }

    private void RunCollisionCheck(Collider firstCollider, Collider secondCollider)
    {
        if (CircleCollider.class.isAssignableFrom(secondCollider.getClass()))
        {
            println("Testing for circle v cirlce");
            firstCollider.CollideAgainstCircle((CircleCollider) secondCollider);
        }
        else if (BoxCollider.class.isAssignableFrom(secondCollider.getClass()))
        {
            println("Testing for box v box");
            firstCollider.CollideAgainstBox((BoxCollider) secondCollider);
        }
    }
}