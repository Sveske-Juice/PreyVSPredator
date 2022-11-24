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

        // println("E_kin: " + m_KineticEnergy);
        m_KineticEnergy = 0f;
    }

    private void ApplyGravity()
    {
        for (int i = 0; i < m_Bodies.size(); i++)
        {
            m_Bodies.get(i).ApplyGravity();
        }
    }

    // Moves all rigidbodies in the scene and calculates the total kinetic energy
    private void MoveObjects(float dt)
    {
        for (int i = 0; i < m_Bodies.size(); i++)
        {
            RigidBody body = m_Bodies.get(i);
            KeepTransformInsideDimensions(body.transform());
            m_KineticEnergy += body.CalcEKin();
            
            if (body == null) continue;

            body.Move();
        }
    }

    // Casts a ray cast against every collider in the scene
    // and returns a RaycastHit object.
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

    // Checks if a point is intersected by any collider in the scene
    // returns the collider the point overlapped with or null.
    public Collider PointOverlap(PVector point, boolean checkingForMouse)
    {
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            if (m_Colliders.get(i).PointInCollider(point))
            {
                Collider collider = m_Colliders.get(i);
                if (!checkingForMouse) // All collision layers accepted if not mouse
                    return collider;
                
                // Check collider layer against mouse collision mask
                int layer = collider.GetCollisionLayer();
                // println("Testing layer: " + layer);
                Scene colliderScene = collider.GetGameObject().GetBelongingToScene(); // Scene connected to collider
                if (colliderScene.GetMouseCollisionMask().IsSet(layer))
                {
                    // Mouse is allowed to collider with layer
                    return collider;
                }

                // Mouse is not allowed to collider with layer
                return null;
            }
        }
        
        return null;
    }

    private void KeepTransformInsideDimensions(Transform transform)
    {
        PVector pos = transform.Position;
        PVector dimensions = transform.GetGameObject().GetBelongingToScene().GetDimensions();

        if (pos.x < -dimensions.x)
            pos.x = dimensions.x;
        else if (pos.x > dimensions.x)
            pos.x = -dimensions.x;
        
        if (pos.y < -dimensions.y)
            pos.y = dimensions.y;
        else if (pos.y > dimensions.y)
            pos.y = -dimensions.y;
        
    
    }
}