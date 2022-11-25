// Interface where the class implementing it will be notified on mouse events
public interface IMouseEventListener
{
    public void OnColliderClick(Collider collider);
    public void OnMouseClick(PVector position);
    public void OnMouseDrag(PVector position);
    public void OnMouseRelease(PVector position);
}