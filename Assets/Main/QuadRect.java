public class QuadRect {
    public ZVector pos;
    public ZVector size;

    public QuadRect(ZVector _pos, ZVector _size)
    {
        pos = _pos;
        size = _size;
    }

    /* Instance methods. */
    public boolean Contains(ZVector point)
    {
        return QuadRect.Contains(this, point); // Call static method
    }

    public boolean Intersects(QuadRect range)
    {
        return QuadRect.Intersects(this, range); // Call static method
    }

    /* Static methods. */
    public static boolean Contains(QuadRect quadRect, ZVector point)
    {
        // Basic point vs AABB collision
        return (    point.x > quadRect.pos.x && point.x < quadRect.pos.x + quadRect.size.x &&
                    point.y > quadRect.pos.y && point.y < quadRect.pos.y + quadRect.size.y);
    }

    public static boolean Intersects(QuadRect quadRect, QuadRect quadRect2)
    {
        // Basic AABB vs AABB detection
        // TODO use BoxCollider implementation
        ZVector rangePos = quadRect2.pos;
        ZVector rangeSize = quadRect2.size;
        // return !(   rangePos.x - rangeSize.x > quadRect.pos.x + quadRect.size.x ||
        //             rangePos.x + rangeSize.x < quadRect.pos.x - quadRect.size.x ||
        //             rangePos.y - rangeSize.y > quadRect.pos.y + quadRect.size.y ||
        //             rangePos.y + rangeSize.y < quadRect.pos.y - quadRect.size.y);
        return !(   quadRect.pos.x > rangePos.x + rangeSize.x ||
                    quadRect.pos.x + quadRect.size.x < rangePos.x ||
                    quadRect.pos.y > rangePos.y + rangeSize.y ||
                    quadRect.pos.y + quadRect.size.y < rangePos.y);

    }
}
