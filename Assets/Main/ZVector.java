// Credit: Zhentao

import java.lang.Math;

public class ZVector
{
    public float x;
    public float y;
    public float z;

    /* #region [rgba(255,122,122, 0.05)] Constructor*/
    public ZVector()
    {
        x = y = z = 0f;
    }

    public ZVector(float _x)
    {
        x = _x;
        y = z = 0f;
    }

    public ZVector(float _x, float _y)
    {
        x = _x;
        y = _y;
        z = 0f;
    }
    
    public ZVector(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }

    /* #endregion */
    public String toString()
    {
        return "[" + x + ", " + y + ", "+ z + "]";
    }

    /* Instance methods. */
    public ZVector add(ZVector vec)
    {
        ZVector newVec = ZVector.add(this, vec); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }
    
    public ZVector sub(ZVector vec)
    {
        ZVector newVec = ZVector.sub(this, vec); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }

    public ZVector mult(float value)
    {
        ZVector newVec = ZVector.mult(this, value); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }

    public ZVector mult(ZVector vec)
    {
        ZVector newVec = ZVector.mult(this, vec); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }

    public ZVector div(float value)
    {
        ZVector newVec = ZVector.div(this, value); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }

    public float mag()
    {
        return ZVector.mag(this); // Call static method
    }

    public ZVector normalize()
    {
        ZVector newVec = ZVector.normalize(this); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }

    public ZVector copy()
    {
        return new ZVector(x, y, z);
    }

    public ZVector rotate(float radians)
    {
        return ZVector.rotate(this, radians); // Call static method
    }

    public float dot(ZVector vec)
    {
        return ZVector.dot(this, vec); // Call static method
    }

    public float dist(ZVector vec)
    {
        return ZVector.dist(this, vec); // Call static method
    }

    public ZVector limit(float limit)
    {
        ZVector newVec = ZVector.limit(this, limit); // Call static method
        x = newVec.x;
        y = newVec.y;
        z = newVec.z;
        return newVec;
    }

    public float angle()
    {
        return ZVector.angle(this); // Call static method
    }

    public float get(int idx)
    {
        switch (idx)
        {
            case 0:
                return x;

            case 1:
                return y;

            case 2:
                return z;

            default:
                return 0f;
        }

    }

    public ZVector abs()
    {
        if (x < 0)
            x = -x;
        
        if (y < 0)
            y = -y;

        if (z < 0)
            z = -z;
        
        return this;
    }

    /* Static methods. */
    public static ZVector add(ZVector vec1, ZVector vec2)
    {
        return new ZVector(vec1.x + vec2.x, vec1.y + vec2.y, vec1.z + vec2.z);
    }
    
    public static ZVector sub(ZVector vec1, ZVector vec2)
    {
        return new ZVector(vec1.x - vec2.x, vec1.y - vec2.y, vec1.z - vec2.z);
    }

    public static ZVector mult(ZVector vec1, float value)
    {
        return new ZVector(vec1.x * value, vec1.y * value, vec1.z * value);
    }

    public static ZVector mult(ZVector vec1, ZVector vec2)
    {
        return new ZVector(vec1.x * vec2.x, vec1.y * vec2.y, vec1.z * vec2.z);
    }

    public static ZVector div(ZVector vec1, float value)
    {
        return new ZVector(vec1.x / value, vec1.y / value, vec1.z / value);
    }

    public static float mag(ZVector vec)
    {
        return (float) Math.sqrt(vec.x*vec.x + vec.y*vec.y + vec.z*vec.z);
    }

    public static ZVector normalize(ZVector vec)
    {
        float m = vec.mag();

        if (m == 0)
            return new ZVector();
        
        return new ZVector(vec.x / m, vec.y / m, vec.z / m);
    }

    public static ZVector rotate(ZVector vec, float radians)
    {
        vec.x = (float) (vec.x * Math.cos(radians) - vec.y * Math.sin(radians));
        vec.y = (float) (vec.x * Math.sin(radians) + vec.y * Math.cos(radians));
        return vec;
    }

    public static float dot(ZVector vec1, ZVector vec2)
    {
        return (vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z);
    }

    public static float dist(ZVector vec1, ZVector vec2)
    {
        ZVector combined = sub(vec1, vec2);
        return (float)Math.sqrt(combined.x*combined.x + combined.y*combined.y + combined.z*combined.z);
    }

    public static ZVector limit(ZVector vec, float limit)
    {
        float m = vec.mag();
        if (m <= limit)
            return vec;

        float f = Math.min(m, limit) / m;
        return ZVector.mult(vec, f);
    }

    public static float angle(ZVector vec)
    {
        return (float) -(Math.atan2((double) vec.x, (double) vec.y) - Math.PI);
    }

    public static float heading(ZVector vec)
    {
        return (float) (360 - (((Math.atan2(vec.x, vec.y) * (180 / Math.PI)) + 90) % 360));
    }
}