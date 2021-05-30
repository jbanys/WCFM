#  Subscriptions Tests

## Specification Tests

### Requirement 1: Subscribe to a radio show

1. Click on `Schedule` tab button.
Outcome: The schedule is opened.

2. Click on a radio show.
Outcome: The detail for the radio show is opened.

3. Click on the subscribe switch to turn it on.
Outcome: The radio show is now subscribed to.

4. Click on `Subscriptions` tab button.
Outcome: The subscriptions are now opened. The radio show the user subscribed to appears in the subscriptions.

### Requirement 2: Unsubscribe from `Subscriptions` tab

1.  Click on `Subscriptions` tab button.
Outcome: The subscriptions are now opened.

2. Click on a subscribed radio show
Outcome: The detail for the radio show is opened, and the subscribe switch is set to on.

3. Click on the subscribe switch to turn it off.
Outcome: The radio show is now unsubscribed.

4. Click on `Schedule` tab button.
Outcome: The schedule is opened.

5. Click on the unsubscribed radio show.
Outcome: The detail for the radio show is opened, and the subscribe switch is set to off.

### Requirement 3: Unsubscribe from `Subscriptions` tab (delete)

1.  Click on `Subscriptions` tab button.
Outcome: The subscriptions are now opened.

2. Swipe left on a subscribed radio show and press `Delete`
Outcome: The radio show is now unsubscribed.

3. Click on `Schedule` tab button.
Outcome: The schedule is opened.

4. Click on the unsubscribed radio show.
Outcome: The detail for the radio show is opened, and the subscribe switch is set to off.

### Requirement 4: Unsubscribe from `Schedule` tab

1. Click on `Schedule` tab button.
Outcome: The schedule is opened.

2. Click on a subscribed radio show
Outcome: The detail for the radio show is opened, and the subscribe switch is set to on.

3. Click on the subscribe switch to turn it off.
Outcome: The radio show is now unsubscribed.

4.  Click on `Subscriptions` tab button.
Outcome: The subscriptions are now opened, and the unsubscribed radio show is no longer in subscriptions.

### Requirement 5: Show detail from `Schedule` and `Subscriptions` are in sync

1. Click on `Schedule` tab button.
Outcome: The schedule is opened.

2. Click on a subscribed radio show
Outcome: The detail for the radio show is opened, and the subscribe switch is set to on.

3.  Click on `Subscriptions` tab button.
Outcome: The subscriptions are now opened.

4. Click on the same subscribed radio show
Outcome: The detail for the radio show is opened, and the subscribe switch is set to on.

5. Switch between the `Schedule` and `Subscriptions` tab and turn the switch on/off
Outcome: Both details will be in sync
