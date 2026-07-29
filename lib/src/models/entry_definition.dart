/// Entry and identity value types for MCP UI DSL §8.9.
///
/// A definition is frequently reached from outside the app — a scanned code,
/// a tag, a link — and the viewer may or may not be signed in. These types
/// carry what the host resolved about that arrival so a document can branch
/// on it through `entry.*` / `identity.*` bindings.
///
/// Everything here is read-only from the document's point of view, and none
/// of it is authority: what a screen offers is decided here, what the system
/// permits is decided at the serving origin.
library entry_definition;

import 'package:flutter/foundation.dart';

/// Who the current session acts as (§8.9.2).
enum IdentityState {
  /// Nobody signed in. The session acts as the bearer of the entry, if any.
  guest,

  /// A principal the host identified.
  identified;

  String get wireName => name;
}

/// The kind of party a principal is.
///
/// Descriptive, never permissive — a document asking "may this viewer manage
/// this medium" reads [EntryContext.canSteward], which the host answers,
/// rather than inferring an answer from the kind.
enum IdentitySubjectKind {
  guest,
  user,
  tenant,
  service;

  String get wireName => name;

  static IdentitySubjectKind? fromWire(String? value) {
    for (final kind in IdentitySubjectKind.values) {
      if (kind.wireName == value) return kind;
    }
    return null;
  }
}

/// The principal a session currently acts as.
@immutable
class IdentityContext {
  const IdentityContext({
    this.state = IdentityState.guest,
    this.subjectKind = IdentitySubjectKind.guest,
    this.subjectRef,
    this.canPromote = false,
  });

  /// The guest identity a session starts from when a host says nothing else.
  static const IdentityContext guest = IdentityContext();

  final IdentityState state;
  final IdentitySubjectKind subjectKind;

  /// Opaque reference to the principal, stable for that principal. Never a
  /// credential and never a personal identifier the document should display
  /// as one.
  final String? subjectRef;

  /// Whether the host can offer sign-in here. False under a policy that never
  /// asks (`open`) and on hosts with no promotion capability.
  final bool canPromote;

  bool get isIdentified => state == IdentityState.identified;

  IdentityContext copyWith({
    IdentityState? state,
    IdentitySubjectKind? subjectKind,
    String? subjectRef,
    bool? canPromote,
  }) {
    return IdentityContext(
      state: state ?? this.state,
      subjectKind: subjectKind ?? this.subjectKind,
      subjectRef: subjectRef ?? this.subjectRef,
      canPromote: canPromote ?? this.canPromote,
    );
  }

  /// The shape `identity.*` bindings resolve against.
  Map<String, dynamic> toBindingMap() {
    return <String, dynamic>{
      'state': state.wireName,
      'subject': <String, dynamic>{
        'kind': subjectKind.wireName,
        'ref': subjectRef,
      },
      'canPromote': canPromote,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is IdentityContext &&
        other.state == state &&
        other.subjectKind == subjectKind &&
        other.subjectRef == subjectRef &&
        other.canPromote == canPromote;
  }

  @override
  int get hashCode => Object.hash(state, subjectKind, subjectRef, canPromote);
}

/// Why a promotion attempt ended the way it did (§8.9.3).
///
/// Collapsing these into "no identity" would leave a document unable to tell
/// "you declined, try again" from "this host cannot sign you in" — the same
/// distinction every established credential API preserves.
enum PromotionOutcome {
  /// The principal changed.
  promoted,

  /// The viewer was asked and said no. Offering again is reasonable.
  declined,

  /// This host cannot identify anyone here. Offering again is not.
  unavailable,

  /// The attempt broke. The reason stays with the host; the document is told
  /// only that it failed, since a failure message is the host's to phrase.
  failed;

  String get wireName => name;
}

/// The result of an [PromotionOutcome.promoted] attempt and nothing else —
/// [identity] is set only when the principal actually changed.
@immutable
class IdentityPromotion {
  const IdentityPromotion._(this.outcome, this.identity);

  const IdentityPromotion.promoted(IdentityContext identity)
      : this._(PromotionOutcome.promoted, identity);

  const IdentityPromotion.declined()
      : this._(PromotionOutcome.declined, null);

  const IdentityPromotion.unavailable()
      : this._(PromotionOutcome.unavailable, null);

  const IdentityPromotion.failed() : this._(PromotionOutcome.failed, null);

  final PromotionOutcome outcome;
  final IdentityContext? identity;

  bool get changed => outcome == PromotionOutcome.promoted;

  @override
  bool operator ==(Object other) =>
      other is IdentityPromotion &&
      other.outcome == outcome &&
      other.identity == identity;

  @override
  int get hashCode => Object.hash(outcome, identity);
}

/// Who stands behind the scanned medium.
@immutable
class EntryIssuer {
  const EntryIssuer({required this.name, this.verified = false});

  final String name;
  final bool verified;

  Map<String, dynamic> toBindingMap() =>
      <String, dynamic>{'name': name, 'verified': verified};

  @override
  bool operator ==(Object other) =>
      other is EntryIssuer && other.name == name && other.verified == verified;

  @override
  int get hashCode => Object.hash(name, verified);
}

/// A disclosure the host wants rendered before or alongside the document.
///
/// [kind] is a closed vocabulary; an unrecognised kind is carried as
/// `advisory` rather than dropped, so a host never loses a message by being
/// newer than the runtime.
@immutable
class EntryNotice {
  const EntryNotice({required this.kind, required this.message});

  factory EntryNotice.fromWire(String? kind, String message) {
    const known = <String>{
      'custodyChanged',
      'targetMoved',
      'degraded',
      'advisory',
    };
    return EntryNotice(
      kind: known.contains(kind) ? kind! : 'advisory',
      message: message,
    );
  }

  final String kind;
  final String message;

  Map<String, dynamic> toBindingMap() =>
      <String, dynamic>{'kind': kind, 'message': message};

  @override
  bool operator ==(Object other) =>
      other is EntryNotice && other.kind == kind && other.message == message;

  @override
  int get hashCode => Object.hash(kind, message);
}

/// How a definition was entered.
///
/// [params] are context from outside the document and are **untrusted input**
/// (§8.9.5) — a document renders them, an origin never trusts them.
@immutable
class EntryContext {
  EntryContext({
    this.route,
    Map<String, dynamic>? params,
    this.issuer,
    List<String>? grantScope,
    this.canSteward = false,
    this.notice,
  })  : params = Map<String, dynamic>.unmodifiable(
          params ?? const <String, dynamic>{},
        ),
        grantScope = List<String>.unmodifiable(
          grantScope ?? const <String>[],
        );

  /// The route the entry resolved to, when it named one.
  final String? route;

  /// Parameters carried by the entry. Distinct from route parameters: these
  /// say what was scanned, and they survive internal navigation.
  final Map<String, dynamic> params;

  final EntryIssuer? issuer;

  /// What this entry is permitted to attempt. The vocabulary belongs to the
  /// origin that enforces it; the runtime only carries it through.
  final List<String> grantScope;

  /// Whether the current principal may manage the medium behind this entry.
  final bool canSteward;

  final EntryNotice? notice;

  /// The shape `entry.*` bindings resolve against.
  Map<String, dynamic> toBindingMap() {
    return <String, dynamic>{
      'route': route,
      'params': Map<String, dynamic>.from(params),
      'issuer': issuer?.toBindingMap(),
      'grant': <String, dynamic>{'scope': List<String>.from(grantScope)},
      'canSteward': canSteward,
      'notice': notice?.toBindingMap(),
    };
  }

  EntryContext copyWith({
    String? route,
    Map<String, dynamic>? params,
    EntryIssuer? issuer,
    List<String>? grantScope,
    bool? canSteward,
    EntryNotice? notice,
  }) {
    return EntryContext(
      route: route ?? this.route,
      params: params ?? this.params,
      issuer: issuer ?? this.issuer,
      grantScope: grantScope ?? this.grantScope,
      canSteward: canSteward ?? this.canSteward,
      notice: notice ?? this.notice,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EntryContext &&
        other.route == route &&
        mapEquals(other.params, params) &&
        other.issuer == issuer &&
        listEquals(other.grantScope, grantScope) &&
        other.canSteward == canSteward &&
        other.notice == notice;
  }

  @override
  int get hashCode => Object.hash(
        route,
        Object.hashAll(params.keys),
        Object.hashAll(params.values),
        issuer,
        Object.hashAll(grantScope),
        canSteward,
        notice,
      );
}
