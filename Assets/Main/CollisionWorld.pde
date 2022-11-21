public class CollisionWorld
{
    /* Members. */
    private ArrayList<Collider> m_Colliders = new ArrayList<Collider>();

    /* Getters/Setters. */

    /* Constructors. */

    /* Methods. */

    public void RegisterCollider(Collider collider) { if (collider == null) return; m_Colliders.add(collider); }

    protected void ResolveCollisions(float dt)
    {
        // Store collisions in this step
        ArrayList<Collision> collisions = new ArrayList<Collision>();
        
        // Detect collisions and create collision containers
        for (int i = 0; i < m_Colliders.size(); i++)
        {
            for (int j = 0; j < m_Colliders.size(); j++)
            {
                if (i == j) break;
                Collider colA = m_Colliders.get(i);
                Collider colB = m_Colliders.get(j);
                //println("Checking for collision between " + colA.GetName() + " on " + colA.GetGameObject().GetName() + " and " +  colB.GetName() + " on " + colB.GetGameObject().GetName());

                if (colA == null || colB == null)
                    continue;
                
                // Check collision between the two colliders
                CollisionPoint points = colA.TestCollision(colB);

                if (points.HasCollision)
                {
                    // Construct collision container
                    Collision collision = new Collision(colA, colB, colA.GetGameObject(), colB.GetGameObject(), points);
                    collisions.add(collision);
                }
            }
        }

        // Resolve collisions for this frame
        for (int i = 0; i < collisions.size(); i++)
        {
            Collision collision = collisions.get(i);
            //println("Collision happened between " + collision.ColA.GetGameObject().GetName() + " and " + collision.ColB.GetGameObject().GetName());
            
            RigidBody A = collision.A.GetComponent(RigidBody.class);
            RigidBody B = collision.B.GetComponent(RigidBody.class);

            PVector normal = collision.Points.Normal;
            PVector tangent = new PVector(-normal.y, normal.x);
        
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

            /* debug
            fill(255, 0, 0);
            circle(collision.Points.A.x, collision.Points.A.y, 10);
            circle(collision.Points.B.x, collision.Points.B.y, 10);
            fill(255);
            */
        }

        //println(1 / Time.dt());
        println("-- new frame --");
    }
}