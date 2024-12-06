package lab5.domain.validators;


import lab5.domain.Utilizator;

public class UtilizatorValidator implements Validator<Utilizator> {
    @Override
    public void validate(Utilizator entity) throws ValidationException {
        System.out.println("[UTilizatorValidator]");
        if(entity.getFirstName().equals(""))
            throw new ValidationException("Numele de familie nu poate fi null");
        if(entity.getLastName().equals(""))
            throw new ValidationException("Prenumele nu poate fi null");
    }
}
