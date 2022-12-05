
public class CollisionWorld
{
    /* Members. */
    protected ArrayList<Collider> m_Colliders = new ArrayList<Collider>();
    protected Scene m_Scene;
    protected QuadTree<Collider> m_ColliderTree;
    protected int m_CollisionChecks = 0;
    private float m_MaxSearchRadius = 400f; // ! This should ideally not be here, but okay for our scenario

    /* Getters/Setters. */
    public void SetBelongingToScene(Scene scene) { m_Scene = scene; }
    public QuadTree<Collider> GetColliderTree() { return m_ColliderTree; }
    public int GetCollisionChecks() { return m_CollisionChecks; }

    /* Constructors. */

    /* Methods. */

    public void RegisterCollider(Collider collider)
    {
        if (collider == null)
            return;
        
        // println("Registering collider: " + collider.GetName());
        m_Colliders.add(collider);
    }

    protected void ResolveCollisions(float dt)
    {
        // Build collider quad tree
        m_ColliderTree = new QuadTree<Collider>(new QuadRect(m_Scene.GetDimensions().copy().mult(-1f), m_Scene.GetDimensions().copy().mult(2f)), 8);

        // Insert all colliders to the quad tree so it gets filled and will parition the layout
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            Collider collider = m_Colliders.get(i);
            
            // Do not include UI colliders
            if (collider.GetGameObject().IsUI())
                continue;
            
            m_ColliderTree.Insert(new QuadPoint<Collider>(collider.transform().GetPosition(), collider));
        }
        // println("quad tree built");
        // Store collisions in this physics step
        ArrayList<Collision> collisions = new ArrayList<Collision>();
        m_CollisionChecks = 0; // Reset checks for this physics step


        // Traverse all cells in the collider tree
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            // Sort collider list based on min extent in x-axis
            CircleCollider colA;
            if (m_Colliders.get(i) instanceof CircleCollider)
                colA = (CircleCollider) m_Colliders.get(i);
            else
                continue;
            
            // Skip the collision check if the collider doesn't need to be checked this frame
            if (colA.GetFramesSinceTick() < colA.GetTickEveryFrame())
            {
                colA.SetFramesSinceTick(colA.GetFramesSinceTick() + 1); // Increment frames since collision check
                continue;
            }
            
            
            colA.SetFramesSinceTick(0); // Reset frames since collision check
            

            BitField colACollisionMask = colA.GetCollisionMask();

            ZVector colPos = colA.transform().GetPosition();
            float radius = colA.GetRadius()*2;
            if (radius > m_MaxSearchRadius) radius = m_MaxSearchRadius;
            QuadCircle range = new QuadCircle(new ZVector(colPos.x, colPos.y), radius);
            ArrayList<QuadPoint<Collider>> points = m_ColliderTree.Query(range, new ArrayList<QuadPoint<Collider>>());
            // println("points: " + points);
 
            // Detect collisions and create collision objects with sweep and prune algorithm
            for (int j = 0; j < points.size(); j++)
            {
                Collider colB = points.get(j).pointData;
                if (colA.GetId() == colB.GetId())
                    continue;
            
                // Check for collision layer
                int colBLayer = colB.GetCollisionLayer();
                // println("Collision layer b: " + colBLayer + " on obj: " + colB.GetName());
                if (!colACollisionMask.IsSet(colBLayer))
                {
                    // Collision is not allowed between theese colliders
                    continue;
                }

                // println("Checking for collision between " + colA.GetName() + " on " + colA.GetGameObject().GetName() + " and " +  colB.GetName() + " on " + colB.GetGameObject().GetName());
                // Check collision between the two colliders
                CollisionPoint colPoints = colA.TestCollision(colB);
                m_CollisionChecks++;

                if (colPoints == null)
                    continue;

                // If any of the colliders are triggers then don't resolve collision
                if (colB.IsTrigger() || colA.IsTrigger())
                {
                    RaiseCollisionTriggerEvent(colA, colB);
                    RaiseCollisionTriggerEvent(colB, colA);
                    continue; // Continue without physically resolving the collision
                }

                /* Collision occured - resolve collision. */

                // Construct collision container
                Collision collision = new Collision(colA, colB, colA.GetGameObject(), colB.GetGameObject(), colPoints);
                //println("Collision happened between " + collision.ColA.GetGameObject().GetName() + " and " + collision.ColB.GetGameObject().GetName());
                
                RigidBody A = collision.A.GetComponent(RigidBody.class);
                RigidBody B = collision.B.GetComponent(RigidBody.class);
                // println("resolving for: " + collision.A.GetName() +  " and: " + collision.B.GetName());

                ZVector normal = collision.Points.Normal;

                // Push back objects
                ZVector BA = ZVector.sub(collision.Points.B, collision.Points.A);

                // The depth of the penetration vector with a little offset so they don't collide again
                float depth = BA.mag() + 1f;
                int divider = 2;

                // Calculate so each object gets pushed as much back
                ZVector resolution = ZVector.div(ZVector.mult(normal, depth), divider);

                ZVector ARes = resolution;
                ZVector BRes = resolution;

                A.transform().AddToPosition(resolution);
                B.transform().SubFromPosition(resolution);

                ZVector tangent = new ZVector(-normal.y, normal.x); // Normal rotated by 90° CCW.

                float Avn = ZVector.dot(normal, A.GetVelocity());
                float Avt = ZVector.dot(tangent, A.GetVelocity());
                
                float Bvn = ZVector.dot(normal, B.GetVelocity());
                float Bvt = ZVector.dot(tangent, B.GetVelocity());

                float newAvnScalar = (Avn * (A.GetMass() - B.GetMass()) + 2 * B.GetMass() * Bvn)/(A.GetMass() + B.GetMass());
                float newBvnScalar = (Bvn * (B.GetMass() - A.GetMass()) + 2 * A.GetMass() * Avn)/(A.GetMass() + B.GetMass());

                ZVector newAvn = ZVector.mult(normal, newAvnScalar);
                ZVector newAvt = ZVector.mult(tangent, Avt);

                ZVector newBvn = ZVector.mult(normal, newBvnScalar);
                ZVector newBvt = ZVector.mult(tangent, Bvt);
                
                ZVector newAVel = ZVector.add(newAvn, newAvt);
                ZVector newBVel = ZVector.add(newBvn, newBvt);
                
                A.SetVelocity(newAVel);
                B.SetVelocity(newBVel);
                    
                // fill(255, 0, 0);
                // circle(collision.Points.A.x, collision.Points.A.y, 10);
                // circle(collision.Points.B.x, collision.Points.B.y, 10);
                // fill(255);
            }
        }

        // println("Collision checks this step: " + collisionChecks);

        // Resolve collisions for this frame
        for (int i = 0; i < collisions.size(); i++)
        {
            Collision collision = collisions.get(i);
            //println("Collision happened between " + collision.ColA.GetGameObject().GetName() + " and " + collision.ColB.GetGameObject().GetName());
            
            RigidBody A = collision.A.GetComponent(RigidBody.class);
            RigidBody B = collision.B.GetComponent(RigidBody.class);
            // println("resolving for: " + collision.A.GetName() +  " and: " + collision.B.GetName());

            ZVector normal = collision.Points.Normal;

            // Push back objects
            ZVector BA = ZVector.sub(collision.Points.B, collision.Points.A);

            // The depth of the penetration vector with a little offset so they don't collide again
            float depth = BA.mag() + 0.01f;
            int divider = 2;

            // Calculate so each object gets pushed as much back
            ZVector resolution = ZVector.div(ZVector.mult(normal, depth), divider);

            ZVector ARes = resolution;
            ZVector BRes = resolution;

            // println("Ares: " + ARes);
            // println("Bres: " + BRes);
            // println("B pos before:" + B.transform().GetPosition());
            A.transform().AddToPosition(resolution);
            B.transform().SubFromPosition(resolution);
            // println("B pos after:" + B.transform().GetPosition());
            

            ZVector tangent = new ZVector(-normal.y, normal.x); // Normal rotated by 90° CCW.

            float Avn = ZVector.dot(normal, A.GetVelocity());
            float Avt = ZVector.dot(tangent, A.GetVelocity());
            
            float Bvn = ZVector.dot(normal, B.GetVelocity());
            float Bvt = ZVector.dot(tangent, B.GetVelocity());


            float newAvnScalar = (Avn * (A.GetMass() - B.GetMass()) + 2 * B.GetMass() * Bvn)/(A.GetMass() + B.GetMass());
            float newBvnScalar = (Bvn * (B.GetMass() - A.GetMass()) + 2 * A.GetMass() * Avn)/(A.GetMass() + B.GetMass());

            ZVector newAvn = ZVector.mult(normal, newAvnScalar);
            ZVector newAvt = ZVector.mult(tangent, Avt);

            ZVector newBvn = ZVector.mult(normal, newBvnScalar);
            ZVector newBvt = ZVector.mult(tangent, Bvt);
            
            ZVector newAVel = ZVector.add(newAvn, newAvt);
            ZVector newBVel = ZVector.add(newBvn, newBvt);

            // println(newAVel);
            // println(newBVel);
            // println("normal: " + normal);
            // println("depth: " + depth);
            // println("normal: " + normal);
            
            A.SetVelocity(newAVel);
            B.SetVelocity(newBVel);

                
            fill(255, 0, 0);
            circle(collision.Points.A.x, collision.Points.A.y, 10);
            circle(collision.Points.B.x, collision.Points.B.y, 10);
            fill(255);
            
        }

        // println("fps: " + 1 / Time.dt());
        
    }

    // Triggers the OnCollisionTrigger method on all components on the collider specified by argument "collider"
    private void RaiseCollisionTriggerEvent(Collider collider, Collider triggeredWith)
    {
        ArrayList<Component> components = collider.GetGameObject().GetComponents();

        // println("Raising event on collider: " + collider.GetName() + " on obj: " + collider.GetGameObject().GetName());
        for (int i = 0; i < components.size(); i++)
        {
            Component component = components.get(i); // Cache component

            // Check if component is implementing a collision trigger event handler
            if (component instanceof ITriggerEventHandler)
            {
                ITriggerEventHandler eventHandler = (ITriggerEventHandler) component;
                eventHandler.OnCollisionTrigger(triggeredWith);
            }

        }
    }

    public void ShowQuadTree(QuadTree quadTree)
    {
        if (quadTree.IsDivided())
        {
            // Recursively show children trees
            ShowQuadTree(quadTree.GetNorthWest());
            ShowQuadTree(quadTree.GetNorthEast());
            ShowQuadTree(quadTree.GetSouthWest());
            ShowQuadTree(quadTree.GetSouthEast());
        }
        else
        {
            stroke(0);
            noFill();
            // println("showing tree at: " + quadTree.GetPosition() + " with size: " + quadTree.GetSize());
            ZVector pos = quadTree.GetBoundary().pos;
            ZVector size = quadTree.GetBoundary().size;

            rect(pos.x, pos.y, size.x, size.y);
            fill(255);
        }
    }
}