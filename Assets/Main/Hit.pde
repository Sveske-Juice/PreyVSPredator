/* NOTE: This should somehow in the future be refactored into collisionPoint so everything uses the same type. 
this is only used for AABB vs AABB and AABB vs segment since i am using two different algorithms for each, and its just easier 
represent theese collision hits this way than CollisionPoint.pde. This would go away if i used something like SAT or GJK.
*/
public class Hit
{
    public Collider collider;
    public PVector hitPoint;
    public PVector penetration;
    public PVector normal;
    public float hitTime;

    public Hit(Collider _collider)
    {
        collider = _collider;
        hitPoint = new PVector();
        penetration = new PVector();
        normal = new PVector();
        hitTime = 0f;
    }
}