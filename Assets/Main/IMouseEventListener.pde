/*
 * Interface where the class implementing it will be notified on mouse events
*/
public interface IMouseEventListener
{
    public void OnColliderClick(Collider collider);
    public void OnMouseClick(ZVector position);
    public void OnMouseDrag(ZVector position);
    public void OnMouseRelease(ZVector position);
}