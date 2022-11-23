public class PhysicsSystem extends CollisionWorld
{
    /* Members. */
    private ArrayList<RigidBody> m_Bodies = new ArrayList<RigidBody>();
    private float m_KineticEnergy = 0f;

    /* Getters/Setters. */

    /* Constructors. */

    /* Methods. */

    public void RegisterBody(RigidBody rigidbody) { if (rigidbody == null) return; m_Bodies.add(rigidbody); }

    public void Step(float dt)
    {
        ApplyGravity();
        ResolveCollisions(dt);
        MoveObjects(dt);

        println("E_kin: " + m_KineticEnergy);
        m_KineticEnergy = 0f;
    }

    private void ApplyGravity()
    {
        for (int i = 0; i < m_Bodies.size(); i++)
        {
            m_Bodies.get(i).ApplyGravity();
        }
    }

    private void MoveObjects(float dt)
    {
        for (int i = 0; i < m_Bodies.size(); i++)
        {
            RigidBody body = m_Bodies.get(i);

            m_KineticEnergy += body.CalcEKin();
            
            if (body == null) continue;

            body.Move();
        }
    }

    public RaycastHit Raycast(Ray ray)
    {
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            RaycastHit hit = m_Colliders.get(i).TestRaycast(ray);
            
            if (hit.GetHit())
                return hit;
        }

        return new RaycastHit(null, null, -1f, false);
    }
}