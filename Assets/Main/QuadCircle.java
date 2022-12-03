import java.lang.Math;

public class QuadCircle
{
    public ZVector pos;
    public float r;
    public float rSq;

    public QuadCircle(ZVector _pos, float _r)
    {
        pos = _pos;
        r = _r;
        rSq = _r*_r;
    }

    public boolean Contains(ZVector point)
    {
        float dist = pos.dist(point);

        if (dist < r)
            return true;
        
        return false;
    }

    public boolean Intersects(QuadRect range)
    {
        ZVector boxHalfExtents = new ZVector(range.size.x / 2f, range.size.y / 2f);
        ZVector boxCenter = new ZVector(range.pos.x + boxHalfExtents.x, range.pos.y + boxHalfExtents.y);

        ZVector diff = ZVector.sub(pos, boxCenter);
        ZVector clamped = Clamp(diff, ZVector.mult(boxHalfExtents, -1f), boxHalfExtents);

        ZVector closestPoint = ZVector.add(boxCenter, clamped);

        ZVector circleToPoint = ZVector.sub(closestPoint, pos);
        float ctpMag = circleToPoint.mag();

        if (ctpMag > r) // No intersection happened
            return false;

        return true;
    }

    /// Clamps a vector between a min and max vector
    private ZVector Clamp(ZVector value, ZVector min, ZVector max)
    {
        ZVector out = value.copy();
        out.x = Clamp(out.x, min.x, max.x);
        out.y = Clamp(out.y, min.y, max.y);
        return out;
    }

    // Clamps a value between a range
    protected float Clamp(float value, float min, float max)
    {
        return Math.max(min, Math.min(max, value));
    }
}
