public class CollisionInfo
{
    // Vector pointing away from the collision
    // applying this vector will push back the object
    public PVector RevertVector;

    // The collider that was collided with
    public Collider Collider;

    public CollisionInfo(PVector _revertVector, Collider _collider)
    {
        RevertVector = _revertVector;
        Collider = _collider;
    }
}