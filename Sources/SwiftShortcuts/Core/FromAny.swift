import Foundation

// MARK: - AnyAction from Any

extension AnyAction {
    init?(_fromValue value: Any) {
        // Synthesize a fake protocol conformance record to AnyActionConvertible
        let conformance = ProtocolConformanceRecord(type: type(of: value), witnessTable: 0)
        let type = unsafeBitCast(conformance, to: AnyActionConvertible.Type.self)

        guard let action = type.anyAction(from: value) else {
            return nil
        }

        self = action
    }
}

// MARK: - AnyViewConvertible

private let actionMetadata: ProtocolMetadata = {
    let module = "SwiftShortcuts"
    let name = "Action"
    let postfix = "_p"
    let mangled = "\(module.count)\(module)\(name.count)\(name)\(postfix)"
    return ProtocolMetadata(type: _typeByName(mangled)!)
}()

private protocol AnyActionConvertible {}

extension AnyActionConvertible {
    static func anyAction(from action: Any) -> AnyAction? {
        guard let witnessTable = _conformsToProtocol(Self.self, actionMetadata.protocolDescriptorVector) else {
            return nil
        }

        let conformanceRecord = ProtocolConformanceRecord(type: Self.self, witnessTable: Int(bitPattern: witnessTable))
        return withUnsafePointer(to: action as! Self) { pointer in makeAnyAction(pointer, conformanceRecord) }
    }
}

@_silgen_name("_swift_shortcuts_makeAnyAction")
func _makeAnyAction<A: Action>(from action: A) -> AnyAction {
    return AnyAction(action)
}

private typealias AnyActionFunction = @convention(thin) (UnsafeRawPointer, ProtocolConformanceRecord) -> AnyAction

private let makeAnyAction: AnyActionFunction = {
    let symbolName = "_swift_shortcuts_makeAnyAction"
    let handle = dlopen(nil, RTLD_GLOBAL)
    let pointer = dlsym(handle, symbolName)
    return unsafeBitCast(pointer, to: AnyActionFunction.self)
}()

// MARK: - [ActionStep] from Any

private protocol ActionStepsConvertible {}

extension ActionStepsConvertible {
    static func actionSteps(from action: Any) -> [ActionStep]? {
        guard let witnessTable = _conformsToProtocol(Self.self, actionMetadata.protocolDescriptorVector) else {
            return nil
        }

        let conformanceRecord = ProtocolConformanceRecord(type: Self.self, witnessTable: Int(bitPattern: witnessTable))
        return withUnsafePointer(to: action as! Self) { pointer in decompose(pointer, conformanceRecord) }
    }
}

@_silgen_name("_swift_shortcuts_decompose")
func _decompose<A: Action>(action: A) -> [ActionStep] {
    if A.Body.self == Never.self {
        return action.decompose()
    }

    let body = action.body
    if let actionStep = body as? ActionStep {
        return [actionStep]
    } else {
        return _decompose(action: body)
    }
}

private typealias DecomposeFunction = @convention(thin) (UnsafeRawPointer, ProtocolConformanceRecord) -> [ActionStep]

private let decompose: DecomposeFunction = {
    let symbolName = "_swift_shortcuts_decompose"
    let handle = dlopen(nil, RTLD_GLOBAL)
    let pointer = dlsym(handle, symbolName)
    return unsafeBitCast(pointer, to: DecomposeFunction.self)
}()

func actionSteps(from value: Any) -> [ActionStep]? {
    // Synthesize a fake protocol conformance record to ActionStepsConvertible
    let conformance = ProtocolConformanceRecord(type: type(of: value), witnessTable: 0)
    let type = unsafeBitCast(conformance, to: ActionStepsConvertible.Type.self)
    guard let actionSteps = type.actionSteps(from: value) else {
        return nil
    }

    return actionSteps
}

// MARK: - Protocol Runtime Information

private struct ProtocolConformanceRecord {
    let type: Any.Type
    let witnessTable: Int
}

private struct ProtocolDescriptor {}

private struct ProtocolMetadata {
    let kind: Int
    let layoutFlags: UInt32
    let numberOfProtocols: UInt32
    let protocolDescriptorVector: UnsafeMutablePointer<ProtocolDescriptor>

    init(type: Any.Type) {
        self = unsafeBitCast(type, to: UnsafeMutablePointer<Self>.self).pointee
    }
}

@_silgen_name("swift_conformsToProtocol")
private func _conformsToProtocol(
    _ type: Any.Type,
    _ protocolDescriptor: UnsafeMutablePointer<ProtocolDescriptor>
) -> UnsafeRawPointer?
