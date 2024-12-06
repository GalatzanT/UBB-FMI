package lab5.domain.validators;

public interface Validator<T> {
    void validate(T entity) throws ValidationException;
}