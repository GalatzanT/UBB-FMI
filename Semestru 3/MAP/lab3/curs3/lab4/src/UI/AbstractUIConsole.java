package UI;

import service.Service;

public abstract class AbstractUIConsole {
    Service serviceconsole;

    public AbstractUIConsole(Service serviceconsole){
        this.serviceconsole=serviceconsole;
    }
}
