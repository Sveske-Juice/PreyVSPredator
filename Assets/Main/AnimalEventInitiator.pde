/*
 * Animal Event Initiator prefab creates a GameObject which will trigger
 * all subscribed responders to the IAnimalEventListener event.
*/
public class AnimalEventInitiatorObject extends GameObject
{
    public AnimalEventInitiatorObject()
    {
        super("Animal Event Initiator Handler");
    }

    @Override
    public void CreateComponents()
    {
        super.CreateComponents();

        // Create behaviour to this object
        AddComponent(new AnimalEventInitiator());
    }
}

public class AnimalEventInitiator extends Component
{
    /* Members. */
    private ArrayList<IAnimalEventListener> m_Listeners = new ArrayList<IAnimalEventListener>();

    /* Getters/Setters. */
    public void RegisterListener(IAnimalEventListener listener) { m_Listeners.add(listener); }

    public AnimalEventInitiator()
    {
        m_Name = "Animal Event Initiator Behaviour";
    }

    /* Methods. */

    /*
     * Gets called from an animal when an animal died. 
     * Will trigger the 'OnAnimalDeath()' event on listeners.
    */
    public void RegisterAnimalDeath(Animal animal, int animalId)
    {
        // Trigger event on listeners
        for (int i = 0; i < m_Listeners.size(); i++)
        {
            m_Listeners.get(i).OnAnimalDeath(animal, animalId);
        }
    }
}