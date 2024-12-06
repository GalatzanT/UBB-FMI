package lab5.domain.validators;

import lab5.domain.Prietenie;

public class PrietenieValidator implements Validator<Prietenie> {


    @Override
    public void validate(Prietenie entity) throws ValidationException {
        System.out.println("[Validator Prietenie]");

    }
}
