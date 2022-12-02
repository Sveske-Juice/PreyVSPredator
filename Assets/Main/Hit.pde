/* NOTE: This should somehow in the future be refactored into collisionPoint so everything uses the same type. 
this is only used for AABB vs AABB and AABB vs segment since i am using two different algorithms for each, and its just easier 
represent theese collision hits this way than CollisionPoint.pde. This would go away if i used something like SAT or GJK.
*/
public class Hit
{
    public Collider collider;
    public ZVector hitPoint;
    public ZVector penetration;
    public ZVector normal;
    public float hitTime;

    public Hit(Collider _collider)
    {
        collider = _collider;
        hitPoint = new ZVector();
        penetration = new ZVector();
        normal = new ZVector();
        hitTime = 0f;
    }
}