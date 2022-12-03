import java.util.Collections;
import java.util.Comparator;

public class CollisionWorld
{
    /* Members. */
    protected ArrayList<Collider> m_Colliders = new ArrayList<Collider>();
    protected Scene m_Scene;
    protected QuadTree<Collider> m_ColliderTree;
    protected int m_VarianceAxis = 0;
    protected int m_CollisionChecks = 0;

    /* Getters/Setters. */
    public void SetBelongingToScene(Scene scene) { m_Scene = scene; }
    public QuadTree<Collider> GetColliderTree() { return m_ColliderTree; }
    public int GetCollisionChecks() { return m_CollisionChecks; }

    /* Constructors. */

    /* Methods. */
    
    // Custom comparator for comparing by min extent
    // to sort in descending order
    private Comparator<Collider> m_CompareAABBMinExtent = new Comparator<Collider>()
    {
        public int compare(Collider a, Collider b)
        {
            if (a.GetMinExtents().get(m_VarianceAxis) > b.GetMinExtents().get(m_VarianceAxis))
                return 1;
            else
                return -1;
        }
    };

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
        m_ColliderTree = new QuadTree<Collider>(new QuadRect(m_Scene.GetDimensions().copy().mult(-1f), m_Scene.GetDimensions().copy().mult(2f)), 4);

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

        ShowQuadTree(m_ColliderTree);

        ArrayList<ArrayList<QuadPoint<Collider>>> colliderSubCells = m_ColliderTree.GetSubCellPoints(new ArrayList<ArrayList<QuadPoint<Collider>>>());
        // println("Collider cells: " + colliderSubCells);
        for (int i = 0; i < colliderSubCells.size(); i++)
        {
            ArrayList<QuadPoint<Collider>> cell = colliderSubCells.get(i);
            for (int j = 0; j < cell.size(); j++)
            {
                QuadPoint<Collider> point = cell.get(j);
                fill(255, 0, 0);
                circle(point.pos.x, point.pos.y, 50f);
            }
        }

        // Store collisions in this physics step
        ArrayList<Collision> collisions = new ArrayList<Collision>();
        m_CollisionChecks = 0; // Reset checks for this physics step

        ZVector centerSum = new ZVector();
        ZVector centerSumSq = new ZVector();
        int colliders = 0;

        // Traverse all cells in the collider tree
        for (int i = 0; i < colliderSubCells.size(); i++)
        {
            // Sort collider list based on min extent in x-axis
            ArrayList<QuadPoint<Collider>> cell = colliderSubCells.get(i);
            Collections.sort(m_Colliders, m_CompareAABBMinExtent);

            // Detect collisions and create collision objects with sweep and prune algorithm
            for (int j = 0; j < cell.size(); j++)
            {
                Collider colA = cell.get(j).pointData;
                float colAMaxExtent = colA.GetMaxExtents().get(m_VarianceAxis);
                BitField colACollisionMask = colA.GetCollisionMask();

                ZVector center = colA.GetCenter();
                ZVector centerC = center.copy().abs();
                centerSum.add(centerC);
                centerSumSq.add(ZVector.mult(centerC, centerC));

                for (int k = j + 1; k < cell.size(); k++)
                {
                    Collider colB = cell.get(k).pointData;

                    // If the colliders are not overlaping on the axis we can safely break since it's sorted
                    if (colB.GetMinExtents().get(m_VarianceAxis) > colAMaxExtent)
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
                    m_CollisionChecks++;

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
        }

        centerSum = ZVector.div(centerSum, colliders);
        centerSumSq = ZVector.div(centerSumSq, colliders);
        ZVector variance = ZVector.sub(centerSumSq, ZVector.mult(centerSum, centerSum));

        float maxVar = variance.get(0);
        m_VarianceAxis = 0;
        if (variance.get(1) > maxVar)
        {
            maxVar = variance.get(1);
            m_VarianceAxis = 1;
        }
        
        if (variance.get(2) > maxVar)
        {
            maxVar = variance.get(2);
            m_VarianceAxis = 2;
        }

        // println("Collision checks this step: " + collisionChecks);

        // Resolve collisions for this frame
        for (int i = 0; i < collisions.size(); i++)
        {
            Collision collision = collisions.get(i);
            //println("Collision happened between " + collision.ColA.GetGameObject().GetName() + " and " + collision.ColB.GetGameObject().GetName());
            
            RigidBody A = collision.A.GetComponent(RigidBody.class);
            RigidBody B = collision.B.GetComponent(RigidBody.class);

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

    private void ShowQuadTree(QuadTree quadTree)
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