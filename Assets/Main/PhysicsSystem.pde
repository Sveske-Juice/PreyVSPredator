public class PhysicsSystem extends CollisionWorld
{
    /* Members. */
    private ArrayList<RigidBody> m_Bodies = new ArrayList<RigidBody>();

    /* Getters/Setters. */

    /* Constructors. */

    /* Methods. */

    public void RegisterBody(RigidBody rigidbody) { if (rigidbody == null) return; m_Bodies.add(rigidbody); }

    public void Step(float dt)
    {
        ApplyGravity();
        ResolveCollisions(dt);
        MoveObjects(dt);
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
            
            if (body == null) continue;

            body.Move();
        }
    }
}