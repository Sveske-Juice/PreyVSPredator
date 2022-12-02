public class CollisionInfo
{
    // Vector pointing away from the collision
    // applying this vector will push back the object
    public ZVector RevertVector;

    // The collider that was collided with
    public Collider Collider;

    public CollisionInfo(ZVector _revertVector, Collider _collider)
    {
        RevertVector = _revertVector;
        Collider = _collider;
    }
}