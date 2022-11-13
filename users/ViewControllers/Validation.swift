
import Foundation

public class Validation {
    
    public static func isNameFieldCorrect(_ firstNameOrLastName: String?) -> Bool {
        guard let firstNameOrLastName = firstNameOrLastName else {
            return false
        }
        return firstNameOrLastName != "" ? true : false
    }
    
   public static func checkOnRegex(_ text: String?, type: ValidationType) -> Bool {
        guard let text = text else {
            return false
        }
        let predicate = text.range(of: type.rawValue, options: .regularExpression)
        return predicate != nil ? true : false
    }
    
   public static func isPasswordsSimillar(_ password: String?, _ confirmPassword: String?) -> Bool {
        return (password == confirmPassword) && (password != "")
    }
    
   public enum ValidationType: String {
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case password  = "^.{8,}$"
    }
        
    
}

