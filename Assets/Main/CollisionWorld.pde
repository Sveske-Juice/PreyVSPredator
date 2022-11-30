import java.util.Collections;
import java.util.Comparator;

public class CollisionWorld
{
    /* Members. */
    protected ArrayList<Collider> m_Colliders = new ArrayList<Collider>();

    /* Getters/Setters. */

    /* Constructors. */

    /* Methods. */
    
    // Custom comparator for comparing by min extent
    // to sort in descending order
    private Comparator<Collider> m_CompareAABBMinExtent = new Comparator<Collider>()
    {
        public int compare(Collider a, Collider b)
        {
            if (a.GetMinExtents().x > b.GetMinExtents().x)
                return 1;
            else
                return -1;
        }
    };

    public void RegisterCollider(Collider collider) { if (collider == null) return; m_Colliders.add(collider); }

    protected void ResolveCollisions(float dt)
    {
        // Store collisions in this physics step
        ArrayList<Collision> collisions = new ArrayList<Collision>();
        int collisionChecks = 0;

        // Sort collider list based on min extent in x-axis
        Collections.sort(m_Colliders, m_CompareAABBMinExtent);
        
        // Detect collisions and create collision objects with sweep and prune algorithm
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            Collider colA = m_Colliders.get(i);
            float colAMaxExtent = colA.GetMaxExtents().x;
            BitField colACollisionMask = colA.GetCollisionMask();

            for (int j = i + 1; j < m_Colliders.size(); j++)
            {
                Collider colB = m_Colliders.get(j);

                // If the colliders are not overlaping on the axis we can safely break since it's sorted
                if (colB.GetMinExtents().x > colAMaxExtent)
                    break;
            

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
                CollisionPoint points = colA.TestCollision(colB);
                collisionChecks++;

                if (points == null)
                    continue;

                // If any of the colliders are triggers then don't resolve collision
                if (colB.IsTrigger() || colA.IsTrigger())
                {
                    RaiseCollisionTriggerEvent(colA, colB);
                    RaiseCollisionTriggerEvent(colB, colA);
                    continue; // Continue without resolving the physically resolving the collision
                }

                // Construct collision container
                Collision collision = new Collision(colA, colB, colA.GetGameObject(), colB.GetGameObject(), points);
                collisions.add(collision);
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

            PVector normal = collision.Points.Normal;

            // Push back objects
            PVector BA = PVector.sub(collision.Points.B, collision.Points.A);

            // The depth of the penetration vector with a little offset so they don't collide again
            float depth = BA.mag() + 0.01f;
            int divider = 2;

            // Calculate so each object gets pushed as much back
            PVector resolution = PVector.div(PVector.mult(normal, depth), divider);

            PVector ARes = resolution;
            PVector BRes = resolution;

            A.transform().AddToPosition(resolution);
            B.transform().SubFromPosition(resolution);
            

            PVector tangent = new PVector(-normal.y, normal.x); // Normal rotated by 90° CCW.

            float Avn = PVector.dot(normal, A.GetVelocity());
            float Avt = PVector.dot(tangent, A.GetVelocity());
            
            float Bvn = PVector.dot(normal, B.GetVelocity());
            float Bvt = PVector.dot(tangent, B.GetVelocity());


            float newAvnScalar = (Avn * (A.GetMass() - B.GetMass()) + 2 * B.GetMass() * Bvn)/(A.GetMass() + B.GetMass());
            float newBvnScalar = (Bvn * (B.GetMass() - A.GetMass()) + 2 * A.GetMass() * Avn)/(A.GetMass() + B.GetMass());

            PVector newAvn = PVector.mult(normal, newAvnScalar);
            PVector newAvt = PVector.mult(tangent, Avt);

            PVector newBvn = PVector.mult(normal, newBvnScalar);
            PVector newBvt = PVector.mult(tangent, Bvt);
            
            PVector newAVel = PVector.add(newAvn, newAvt);
            PVector newBVel = PVector.add(newBvn, newBvt);

            // println(newAVel);
            // println(newBVel);
            
            A.SetVelocity(newAVel);
            B.SetVelocity(newBVel);

            /*        debug      
            fill(255, 0, 0);
            circle(collision.Points.A.x, collision.Points.A.y, 10);
            circle(collision.Points.B.x, collision.Points.B.y, 10);
            fill(255);
             */
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
}